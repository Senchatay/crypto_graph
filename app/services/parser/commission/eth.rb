# frozen_string_literal: true

module Parser
  module Commission
    # Pick ETH commission from web
    module ETH
      URL = "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=#{ENV['ETHERSCAN_API_KEY']}".freeze
      def self.call
        @call ||= begin
          response = Faraday.get(URL)
          JSON.parse(response.body)['FastGasPrice'].to_f * 21_000 / 1_000_000_000
        end
      end
    end
  end
end
