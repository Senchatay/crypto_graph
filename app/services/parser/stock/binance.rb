# frozen_string_literal: true

module Parser
  module Stock
    # Pick exnode.ru exchanges
    class Binance < Base
      STOCK_NAME = 'binance.com'
      URL = 'https://www.binance.com/api/v3'
      EXCEPTED_CURRENCY = %i[
        VPAD ATLAS PPT STRK XAI NGL TAMA STND RACA PNT CND LTO CORE COMBO RLY
        SWRV BCUG
      ].freeze

      def self.spot_nodes
        symbols = exchange_info
        book_ticker.map do |info|
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

      def self.exchange_info
        response = Faraday.get("#{URL}/exchangeInfo")
        return {} unless response.success?

        JSON.parse(response.body)['symbols'].each_with_object({}) do |pair, hash|
          hash[pair['symbol']] = { currency_from: pair['baseAsset'], currency_to: pair['quoteAsset'] }
        end
      end

      def self.book_ticker
        response = Faraday.get("#{URL}/ticker/bookTicker")
        JSON.parse(response.body)
      end
    end
  end
end
