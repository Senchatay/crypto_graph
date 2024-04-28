# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class KuCoin < Base
      STOCK_NAME = 'kucoin.com'
      API_URL = 'https://api.kucoin.com/api/v1/market/allTickers'
      P2P_URL = 'https://www.kucoin.com/'
      P2P_CRYPTO = %w[USDT BTC KCS ETH USDC].freeze
      P2P_FIAT = %w[RUB USD EUR].freeze

      def self.spot_nodes
        spot_info.map do |info|
          currency_from, currency_to = info['symbol'].split('-')
          amount_from, amount_to = info.values_at('sell', 'buy').map(&:to_f)
          next if [amount_from, amount_to].any?(&:zero?)

          [
            node(currency_from, currency_to, amount_to:),
            node(currency_to, currency_from, amount_from:)
          ]
        end.compact.flatten
      end

      def self.spot_info
        response = Faraday.get(API_URL)
        return [] unless response.success?

        JSON.parse(response.body)['data']['ticker']
      end

      def self.p2p_nodes
        @connection = Faraday.new(P2P_URL)
        begin
          P2P_FIAT.map do |fiat|
            P2P_CRYPTO.map do |crypto|
              buy_info = p2p_info(crypto, fiat, 'BUY')
              sell_info = p2p_info(crypto, fiat, 'SELL')
              next if [buy_info, sell_info].any?(&:nil?)

              [
                node(crypto, fiat, amount_to: buy_info['floatPrice'].to_f),
                node(fiat, crypto, amount_from: sell_info['floatPrice'].to_f)
              ]
            end.compact
          end.flatten
        ensure
          @connection.close
        end
      end

      def self.p2p_info(currency, legal, side)
        response = @connection.get(
          '_api/otc/ad/list',
          {
            status: 'PUTUP',
            currency:,
            legal:,
            page: 2,
            pageSize: 1,
            side:
          }
        )
        return [] unless response.success?

        JSON.parse(response.body)['items'].first
      end
    end
  end
end
