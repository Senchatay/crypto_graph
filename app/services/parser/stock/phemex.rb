# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class Phemex < Base
      STOCK_NAME = 'phemex.com'
      API_URL = 'https://api.phemex.com'

      def self.spot_nodes
        symbols = exchange_info
        spot_info.map do |info|
          amount_from = info['askEp'].to_f / 10**8
          amount_to = info['bidEp'].to_f / 10**8
          symbol = info['symbol']
          next if [amount_from, amount_to].any?(&:zero?)
          next if [symbol, symbols[symbol]].any?(&:nil?)

          [
            node(
              symbols[symbol][:currency_from],
              symbols[symbol][:currency_to],
              amount_from:
            ),
            node(
              symbols[symbol][:currency_to],
              symbols[symbol][:currency_from],
              amount_to:
            )
          ]
        end.compact.flatten
      end

      def self.exchange_info
        response = Faraday.get("#{API_URL}/public/products")
        return {} unless response.success?

        JSON.parse(response.body)['data']['products'].each_with_object({}) do |pair, hash|
          hash[pair['symbol']] = { currency_from: pair['quoteCurrency'], currency_to: pair['baseCurrency'] }
        end
      end

      def self.spot_info
        response = Faraday.get("#{API_URL}/md/spot/ticker/24hr/all")
        return [] unless response.success?

        JSON.parse(response.body)['result']
      end
    end
  end
end
