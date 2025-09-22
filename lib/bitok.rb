# frozen_string_literal: true

require 'bitok/version'
require 'bitok/configuration'
require 'bitok/api/api'
require 'bitok/api/request'

# Parent module for all classes
module Bitok
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end
  end
end
