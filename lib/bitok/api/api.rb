# frozen_string_literal: true

module Bitok
  # Namespace to access Bitok api methods
  class API
    class << self
      def get_networks
        Request.get(path: "/v1/basics/networks/")
      end

      def get_tokens
        Request.get(path: "/v1/basics/tokens/")
      end

      def create_registration(network:, direction:, address:, tx_hash:, token_id:,  client_id: nil)
        Request.post(
          body: {
            client_id: client_id,
            direction: direction,
            network: network,
            tx_hash: tx_hash,
            token_id: token_id,
            output_address: address
          },
          path: "/v1/transfers/register/"
        )
      end

      def create_registration_attempt(network:, direction:, address:, token_id: nil, client_id: nil, amount: nil, attempt_id: nil)
        address_key = direction == 'incoming' ? :input_address : :output_address
        Request.post(
          body: {
            client_id: client_id,
            direction: direction,
            network: network,
            token_id: token_id,
            amount: amount,
            attempt_id: attempt_id,
          }.merge(address_key => address)
           .compact,
          path: "/v1/transfers/register-attempt/"
        )
      end

      def create_manual_check_address(network:, address:)
        Request.post(
          body: {
            network: network,
            address: address
          },
          path: "/v1/manual-checks/check-address/"
        )
      end

      def get_transfer(transfer_id)
        Request.get(path: "/v1/transfers/#{transfer_id}/")
      end

      def get_transfer_exposure(transfer_id)
        Request.get(path: "/v1/transfers/#{transfer_id}/exposure/")
      end

      def get_transfer_counterparty(transfer_id)
        Request.get(path: "/v1/transfers/#{transfer_id}/counterparty/")
      end

      def get_transfer_risks(transfer_id)
        Request.get(path: "/v1/transfers/#{transfer_id}/risks/")
      end

      def get_manual_check_address_details(check_id)
        Request.get(path: "/v1/manual-checks/#{check_id}/")
      end

      def get_manual_check_address_risks(check_id)
        Request.get(path: "/v1/manual-checks/#{check_id}/risks/")
      end

      def get_manual_check_address_exposure(check_id)
        Request.get(path: "/v1/manual-checks/#{check_id}/address-exposure/")
      end
    end
  end
end
