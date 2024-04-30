# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class Mexc < Base
      STOCK_NAME = 'mexc.com'
      API_URL = 'https://api.mexc.com/api/v3'
      P2P_URL = 'https://p2p.mexc.com/api/market'
      P2P_CRYPTO = {
        USDT: '128f589271cb4951b03e71e6323eb7be',
        BTC: 'febc9973be4d4d53bb374476239eb219',
        ETH: '93c38b0169214f8689763ce9a63a73ff',
        USDC: '34309140878b4ae99f195ac091d49bab'
      }.freeze
      P2P_FIAT = %w[RUB].freeze

      def self.spot_nodes
        symbols = exchange_info
        spot_info.map do |info|
          amount_from, amount_to = info.values_at('askPrice', 'bidPrice').map(&:to_f)
          next if [amount_from, amount_to].any?(&:zero?)

          [
            node(
              symbols[info['symbol']][:currency_from],
              symbols[info['symbol']][:currency_to],
              amount_to:
            ),
            node(
              symbols[info['symbol']][:currency_to],
              symbols[info['symbol']][:currency_from],
              amount_from:
            )
          ]
        end.compact.flatten
      end

      def self.spot_info
        response = Faraday.get("#{API_URL}/ticker/bookTicker")
        return [] unless response.success?

        JSON.parse(response.body)
      end

      def self.exchange_info
        response = Faraday.get("#{API_URL}/exchangeInfo")
        return {} unless response.success?

        JSON.parse(response.body)['symbols'].each_with_object({}) do |pair, hash|
          hash[pair['symbol']] = { currency_from: pair['baseAsset'], currency_to: pair['quoteAsset'] }
        end
      end

      def self.p2p_nodes
        @connection = Faraday.new(P2P_URL)
        begin
          P2P_FIAT.map do |fiat|
            P2P_CRYPTO.map do |crypto, coin_id|
              buy_info = p2p_info(coin_id, fiat, 'BUY')
              sell_info = p2p_info(coin_id, fiat, 'SELL')
              next if [buy_info['price'], sell_info['price']].any?(&:nil?)
              next if [buy_info['price'], sell_info['price']].any?(&:zero?)

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

      def self.p2p_info(coin_id, currency, side)
        response = @connection.get(
          '_api/otc/ad/list',
          {
            coinId: coin_id,
            currency:,
            tradeType: side
          }
        )
        return {} unless response.success?

        JSON.parse(response.body)['data'][1]
      end
    end
  end
end
