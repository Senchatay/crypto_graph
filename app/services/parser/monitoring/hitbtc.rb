# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class HitBTC
      URL = 'https://api.hitbtc.com/api/3'

      def self.load
        symbols = exchange_info
        list = book_ticker.first(::Loader::MonitoringLoader::EXCHANGE_LIMIT).map do |symbol, info|
          amount_from, amount_to = info.values_at('ask', 'bid').map(&:to_f)
          pair = symbols[symbol]
          next if [amount_from, amount_to].any?(&:zero?)
          next if pair.nil? || pair[:currency_to].nil? || pair[:currency_from].nil?

          [
            node(pair[:currency_from], pair[:currency_to], amount_to:),
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
        response = Faraday.get("#{URL}/public/symbol")
        return {} unless response.success?

        JSON.parse(response.body).each_with_object({}) do |pair, hash|
          hash[pair[0]] = { currency_from: pair[1]['base_currency'], currency_to: pair[1]['quote_currency'] }
        end
      end

      def self.book_ticker
        response = Faraday.get("#{URL}/public/ticker")
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
