# frozen_string_literal: true

require "net/http"
require "json"
require "openssl"
require "base64"

module Bitok
  # Interface to GET, POST, PUT
  class Request
    Error = Class.new(StandardError)

    class << self
      def get(path:, body: nil, headers: {})
        new(path: path).get(body, headers)
      end

      def put(path:, body:, headers: {})
        new(path: path).put(body, headers)
      end
    end

    attr_reader :path, :uri

    def initialize(path:)
      @path = path
      @uri = URI.join(Bitok.configuration.base_url, path.to_s)
    end

    def get(body, headers)
      req = Net::HTTP::Get.new(uri)
      inject_headers!(req, "GET", body, headers)
      valid_response!(send_request(req))
    end

    def post(body, headers)
      req = Net::HTTP::Post.new(uri)
      inject_headers!(req, "POST", body, headers, json: true)
      req.body = canonical_json(body)
      valid_response!(send_request(req))
    end

    private

    # ------------------- Headers / Signature -------------------

    def inject_headers!(request, http_method, body, extra_headers, json: false)
      ts = DateTime.now.strftime("%Q")
      request["API-KEY-ID"] = Bitok.configuration.api_key
      request["API-TIMESTAMP"] = ts
      request["API-SIGNATURE"] = build_signature(
        http_method: http_method,
        endpoint_with_query: path_with_query(uri),
        timestamp_ms: ts,
        json_payload: body
      )
      request["Content-Type"] = "application/json" if json
      Array(extra_headers).each { |k, v| request[k] = v }
    end

    def path_with_query(u)
      u.query ? "#{u.path}?#{u.query}" : u.path
    end

    def canonical_json(obj)
      return "" if obj.nil? || (obj.respond_to?(:empty?) && obj.empty?)
      JSON.generate(obj, separators: [",", ":"], quirks_mode: false)
    end

    def build_signature(http_method:, endpoint_with_query:, timestamp_ms:, json_payload:)
      string_to_sign = [
        http_method,
        endpoint_with_query,
        timestamp_ms
      ].join("\n")

      payload_present = !(json_payload.nil? || (json_payload.respond_to?(:empty?) && json_payload.empty?))
      if payload_present
        string_to_sign += "\n" + canonical_json(json_payload)
      end

      secret = Bitok.configuration.private_key
      raw = OpenSSL::HMAC.digest("sha256", secret, string_to_sign)
      Base64.strict_encode64(raw)
    end

    # ------------------- HTTP -------------------

    def send_request(request)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
    end

    def valid_response!(resp)
      body = resp.body.to_s
      json = body.empty? ? {} : JSON.parse(body) rescue { "raw" => body }

      return json if resp.is_a?(Net::HTTPSuccess)

      raise Error, {
        status: resp.code,
        reason: resp.message,
        payload: json
      }.to_json
    end
  end
end
