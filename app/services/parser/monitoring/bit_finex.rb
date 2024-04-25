# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class BitFinex
      URL = 'https://api-pub.bitfinex.com/v2/tickers?symbols=ALL'

      def self.load
        list = exchange_info.map do |info|
          pair = info[0][/(?<=t).*/]
          if pair.include?(':')
            currency_from, currency_to = pair.split(':')
          else
            currency_from = pair[...3]
            currency_to = pair[-3...]
          end
          amount_bid = info[1]
          amount_ask = info[3]
          next if [amount_from, amount_to].any?(&:zero?)

          [
            node(currency_from, currency_to, amount_to: amount_bid),
            node(currency_to, currency_from, amount_from: amount_ask)
          ]
        end.flatten.compact
        new(list).push_to_graph
      end

      def self.exchange_info
        response = Faraday.get("#{URL}/market/tickers?category=spot")
        return [] unless response.success?

        JSON.parse(response.body)
      end

      def self.node(currency_from, currency_to, amount_from: 1, amount_to: 1)
        {
          exchanger: 'bitfinex.com',
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
