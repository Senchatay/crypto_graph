# frozen_string_literal: true

module Parser
  module Stock
    # Pick exnode.ru exchanges
    class Bybit < Base
      STOCK_NAME = 'bybit.com'
      URL = 'https://api.bybit.com/v5'
      P2P_URL = 'https://api2.bybit.com'
      P2P_CRYPTO = %w[USDT BTC ETH USDC].freeze
      P2P_FIAT = %w[RUB].freeze # USD EUR

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

      def self.p2p_nodes
        @connection = Faraday.new(P2P_URL)
        begin
          P2P_FIAT.map do |fiat|
            P2P_CRYPTO.map do |crypto|
              buy_info = p2p_info(crypto, fiat, '1')
              sell_info = p2p_info(crypto, fiat, '0')
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

      def self.p2p_info(token, currency, side)
        response = @connection.post(
          'fiat/otc/item/online',
          {
            amount: '',
            authMaker: false,
            canTrade: false,
            currencyId: currency,
            page: '1',
            payment: [],
            side:,
            size: '2',
            tokenId: token,
            userId: 175_797_104
          }
        )
        return [] unless response.success?

        JSON.parse(response.body)['result']['items'].last
      end
    end
  end
end
