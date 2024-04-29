# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class Bitpapa < Base
      STOCK_NAME = 'bitpapa.com'
      P2P_URL = 'https://bitpapa.com'
      P2P_CRYPTO = %w[USDT TON BTC ETH XMR].freeze
      P2P_FIAT = %w[RUB USD EUR].freeze

      def self.p2p_nodes
        @connection = Faraday.new(P2P_URL)
        begin
          P2P_FIAT.map do |fiat|
            P2P_CRYPTO.map do |crypto|
              buy_info = p2p_info(crypto, fiat, 'buy')
              sell_info = p2p_info(crypto, fiat, 'sell')
              next if [buy_info, sell_info].any?(&:nil?)

              [
                node(crypto, fiat, amount_to: buy_info['price'].to_f),
                node(fiat, crypto, amount_from: sell_info['price'].to_f)
              ]
            end.compact
          end.flatten
        ensure
          @connection.close
        end
      end

      def self.p2p_info(crypto_currency_code, currency_code, side)
        response = @connection.get(
          'api/v1/pro/search',
          {
            type: side,
            page: '1',
            sort: "#{'-' if side == 'buy'}price",
            currency_code:,
            crypto_currency_code:
          }
        )
        return [] unless response.success?

        JSON.parse(response.body)['ads'][1]
      end
    end
  end
end
