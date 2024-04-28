# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class KuCoin < Base
      STOCK_NAME = 'kucoin.com'
      API_URL = 'https://api.kucoin.com/api/v1/market/allTickers'
      P2P_URL = 'https://www.kucoin.com/_api/otc/ad/list'
      P2P_CRYPTO = %w[USDT BTC KCS ETH USDC].freeze

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
        P2P_CRYPTO.map do |crypto|
          sell = node('RUB', crypto, amount_from: p2p_info(crypto, 'SELL')['floatPrice'].to_f)
          buy = node(crypto, 'RUB', amount_to: p2p_info(crypto, 'BUY')['floatPrice'].to_f)

          [buy, sell]
        end.flatten
      end

      def self.p2p_info(currency, side)
        response = Faraday.get(
          P2P_URL,
          {
            status: 'PUTUP',
            currency:,
            legal: 'RUB',
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
