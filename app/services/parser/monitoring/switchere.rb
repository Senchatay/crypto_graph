# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class Switchere
      URL = 'https://switchere.com/api/v2/public/ticker'
      MAPPING = {
        'USDT20' => :'USDT ERC20',
        'USDTTRC20' => :'USDT TRC20'
      }.freeze

      def self.load
        list = exchange_info.first(::Loader::PricesLoader::NODES_LIMIT).map do |info|
          currency_from, currency_to = info['name'].split('-')
          currency_from = MAPPING[currency_from] if MAPPING.key?(currency_from)
          currency_to = MAPPING[currency_to] if MAPPING.key?(currency_to)
          [
            node(currency_from, currency_to, amount_to: info['bid'].to_f),
            node(currency_to, currency_from, amount_from: info['ask'].to_f)
          ]
        end.flatten
        new(list).push_to_graph
      end

      def self.node(currency_from, currency_to, amount_from: 1, amount_to: 1)
        {
          exchanger: 'switchere.com',
          currency_from:,
          currency_to:,
          amount_from:,
          amount_to:
        }
      end

      def self.exchange_info
        response = Faraday.get(URL)
        return [] unless response.success?

        JSON.parse(response.body)
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
