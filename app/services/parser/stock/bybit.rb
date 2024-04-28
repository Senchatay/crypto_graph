# frozen_string_literal: true

module Parser
  module Stock
    # Pick exnode.ru exchanges
    class Bybit < Base
      STOCK_NAME = 'bybit.com'
      URL = 'https://api.bybit.com/v5'

      def self.spot_nodes
        symbols = exchange_info
        book_ticker.map do |info|
          amount_from, amount_to = info.values_at('ask1Price', 'bid1Price').map(&:to_f)
          pair = symbols[info['symbol']]
          next if [amount_from, amount_to].any?(&:zero?)
          next if pair.nil?

          [
            node(
              pair[:currency_from],
              pair[:currency_to],
              amount_to:
            ),
            node(
              pair[:currency_to],
              pair[:currency_from],
              amount_from:
            )
          ]
        end.compact.flatten
      end

      def self.exchange_info
        response = Faraday.get("#{URL}/market/instruments-info?category=spot")
        return {} unless response.success?

        JSON.parse(response.body)['result']['list'].each_with_object({}) do |pair, hash|
          hash[pair['symbol']] = { currency_from: pair['baseCoin'], currency_to: pair['quoteCoin'] }
        end
      end

      def self.book_ticker
        response = Faraday.get("#{URL}/market/tickers?category=spot")
        JSON.parse(response.body)['result']['list']
      end
    end
  end
end
