# frozen_string_literal: true

require 'test_helper'

class BitokConfiguration < Minitest::Test
  describe Bitok::Configuration do
    let(:new_base_url) { 'example.com' }

    describe 'with configuration block' do
      before do
        Bitok.configure do |config|
          config.api_key = ENV['BITOK_API_KEY']
          config.private_key = ENV['BITOK_PRIVATE_KEY']
        end
      end

      def test_it_returns_api_key
        assert_equal Bitok.configuration.api_key, ENV['BITOK_API_KEY']
      end

      def test_it_returns_private_key
        assert_equal(
          Bitok.configuration.private_key, ENV['BITOK_PRIVATE_KEY']
        )
      end

      def test_it_resassigns_base_url
        Bitok.configure { |config| config.base_url = new_base_url }
        assert_equal Bitok.configuration.base_url, new_base_url
      end
    end

    describe 'without configuration keys' do
      before do
        Bitok.reset
      end

      def test_it_raises_api_key_error
        assert_raises(Bitok::Configuration::Error) do
          Bitok.configuration.api_key
        end
      end

      def test_it_raises_private_key_error
        assert_raises(Bitok::Configuration::Error) do
          Bitok.configuration.private_key
        end
      end
    end
  end
end
