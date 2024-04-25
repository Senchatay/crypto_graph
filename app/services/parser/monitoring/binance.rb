# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class Binance
      URL = 'https://www.binance.com/api/v3'

      def self.load
        symbols = exchange_info
        list = book_ticker.first(::Loader::MonitoringLoader::EXCHANGE_LIMIT).map do |info|
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
        end.flatten.compact
        new(list).push_to_graph
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

      def self.node(currency_from, currency_to, amount_from: 1, amount_to: 1)
        {
          exchanger: 'binance.com',
          currency_from:,
          currency_to:,
          amount_from:,
          amount_to:
        }
      end

      attr_accessor :list

      def initialize(list)
        @list = list
      end

      def push_to_graph
        list.each do |hash|
          Loader::ChangerLoader.push!(
            hash[:exchanger],
            {
              hash[:currency_from].to_sym => hash[:amount_from],
              hash[:currency_to].to_sym => hash[:amount_to]
            }
          )
        end
      end
    end
  end
end
