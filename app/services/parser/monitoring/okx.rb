# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    class OKX
      URL = 'https://www.okx.com/api/v5/market/tickers?instType=SPOT'

      def self.load
        list = exchange_info.first(::Loader::MonitoringLoader::EXCHANGE_LIMIT).map do |info|
          currency_from, currency_to = info['instId'].split('-')
          [
            node(currency_from, currency_to, amount_to: info['bidPx'].to_f),
            node(currency_to, currency_from, amount_from: info['askPx'].to_f)
          ]
        end.flatten
        new(list).push_to_graph
      end

      def self.node(currency_from, currency_to, amount_from: 1, amount_to: 1)
        {
          exchanger: 'okx.com',
          currency_from:,
          currency_to:,
          amount_from:,
          amount_to:
        }
      end

      def self.exchange_info
        response = Faraday.get(URL)
        return [] unless response.success?

        JSON.parse(response.body)['data']
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
