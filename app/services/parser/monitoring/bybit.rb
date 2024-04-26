# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class Bybit
      URL = 'https://api.bybit.com/v5'

      def self.load
        symbols = exchange_info
        list = book_ticker.map do |info|
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
        end.flatten.compact
        new(list).push_to_graph
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

      def self.node(currency_from, currency_to, amount_from: 1, amount_to: 1)
        {
          exchanger: 'bybit.com',
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