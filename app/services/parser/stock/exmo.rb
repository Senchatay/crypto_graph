# frozen_string_literal: true

module Parser
  module Stock
    # Pick BTC commission from web
    class Exmo < Base
      STOCK_NAME = 'exmo.me'
      URL = 'https://api.exmo.com/v1.1/ticker'

      def self.spot_nodes
        spot_info.map do |pair, info|
          currency_to, currency_from = pair.split('_').split_by_parity
          currency_from = ['USDT ERC20', 'USDT TRC20'] if currency_from == 'USDT'
          currency_to = ['USDT ERC20', 'USDT TRC20'] if currency_to == 'USDT'
          currency_from.map do |from|
            currency_to.map do |to|
              [
                node(from, to, amount_from: info['sell_price'].to_f),
                node(to, from, amount_to: info['buy_price'].to_f)
              ]
            end
          end
        end.flatten
      end

      def self.spot_info
        response = Faraday.get(URL)
        return [] unless response.success?

        JSON.parse(response.body)
      end
    end
  end
end
