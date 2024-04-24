# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class SimpleSwap
      URL = 'https://api.simpleswap.io'
      EXCHANGE_LIMIT = 40

      def self.load
        list = market_info.first(EXCHANGE_LIMIT).map do |info|
          {
            exchanger: 'simpleswap',
            currency_from: info['currency_from'].upcase,  # check case
            currency_to: info['currency_to'].upcase,      # check case
            amount_from: 1,
            amount_to: info['rate'].to_f
          }
        end
        new(list).push_to_graph
      end

      def self.market_info
        response = Faraday.get("#{URL}/get_market_info")
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
