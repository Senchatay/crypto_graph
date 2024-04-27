# frozen_string_literal: true

module Parser
  module Stock
    # Pick BTC commission from web
    class OKX < Base
      STOCK_NAME = 'okx.com'
      URL = 'https://www.okx.com/api/v5/market/tickers?instType=SPOT'

      def self.spot_nodes
        spot_info.map do |info|
          currency_from, currency_to = info['instId'].split('-')
          [
            node(currency_from, currency_to, amount_to: info['bidPx'].to_f),
            node(currency_to, currency_from, amount_from: info['askPx'].to_f)
          ]
        end.flatten
      end

      def self.spot_info
        response = Faraday.get(URL)
        return [] unless response.success?

        JSON.parse(response.body)['data']
      end
    end
  end
end
