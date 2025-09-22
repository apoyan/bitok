# frozen_string_literal: true

require 'test_helper'

class BitokAPI < Minitest::Test
  describe Bitok::API do
    describe 'send GET Bitok requests' do
      let(:vault_name) { 'test_vault' }

      before do
        Bitok.reset
        Bitok.configure do |config|
          config.api_key = ENV['BITOK_API_KEY']
          config.private_key = ENV['BITOK_PRIVATE_KEY']
        end
      end
    end
  end
end
