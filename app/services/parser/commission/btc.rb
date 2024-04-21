# frozen_string_literal: true

module Parser
  module Commission
    # Pick BTC commission from web
    module BTC
      URL = 'https://mempool.space/api/v1/fees/recommended'
      def self.call
        @call ||= begin
          response = Faraday.get(URL)
          JSON.parse(response.body)['fastestFee'].to_f / 100_000
        end
      end
    end
  end
end
