# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class Coinex < Base
      STOCK_NAME = 'coinex.com'
      API_URL = 'https://api.coinex.com/v2/spot'

      def self.spot_nodes
        symbols = exchange_info
        spot_info.map do |info|
          amount_to = info['last'].to_f
          symbol = info['market']
          next if amount_to.zero?
          next if [symbol, symbols[symbol]].any?(&:nil?)

          [
            node(
              symbols[symbol][:currency_from],
              symbols[symbol][:currency_to],
              amount_to:
            ),
            node(
              symbols[symbol][:currency_to],
              symbols[symbol][:currency_from],
              amount_from: amount_to
            )
          ]
        end.compact.flatten
      end

      def self.exchange_info
        response = Faraday.get("#{API_URL}/market")
        return {} unless response.success?

        JSON.parse(response.body)['data'].each_with_object({}) do |pair, hash|
          hash[pair['market']] = { currency_from: pair['base_ccy'], currency_to: pair['quote_ccy'] }
        end
      end

      def self.spot_info
        response = Faraday.get("#{API_URL}/ticker")
        return [] unless response.success?

        JSON.parse(response.body)['data']
      end
    end
  end
end
