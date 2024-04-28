# frozen_string_literal: true

module Parser
  module Stock
    # Pick exnode.ru exchanges
    class HitBTC < Base
      STOCK_NAME = 'binance.com'
      URL = 'https://api.hitbtc.com/api/3'

      def self.spot_nodes
        symbols = exchange_info
        book_ticker.map do |symbol, info|
          amount_from, amount_to = info.values_at('ask', 'bid').map(&:to_f)
          pair = symbols[symbol]
          next if [amount_from, amount_to].any?(&:zero?)
          next if pair.nil? || pair[:currency_to].nil? || pair[:currency_from].nil?

          [
            node(pair[:currency_from], pair[:currency_to], amount_to:),
            node(
              pair[:currency_to],
              pair[:currency_from],
              amount_from:
            )
          ]
        end.flatten.compact
      end

      def self.exchange_info
        response = Faraday.get("#{URL}/public/symbol")
        return {} unless response.success?

        JSON.parse(response.body).each_with_object({}) do |pair, hash|
          hash[pair[0]] = { currency_from: pair[1]['base_currency'], currency_to: pair[1]['quote_currency'] }
        end
      end

      def self.book_ticker
        response = Faraday.get("#{URL}/public/ticker")
        JSON.parse(response.body)
      end
    end
  end
end
