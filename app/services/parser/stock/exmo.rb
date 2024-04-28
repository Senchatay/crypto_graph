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
              amount_from, amount_to = info.values_at('sell_price', 'buy_price').map(&:to_f)
              next if [amount_from, amount_to].any?(&:zero?)

              [
                node(from, to, amount_from:),
                node(to, from, amount_to:)
              ]
            end
          end
        end.compact.flatten
      end

      def self.spot_info
        response = Faraday.get(URL)
        return [] unless response.success?

        JSON.parse(response.body)
      end
    end
  end
end
