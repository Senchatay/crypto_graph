# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    class BestChange
      CURRENCIES_LIMIT = 40

      def self.load
        currencies = API::BestChange.currencies.values.first(CURRENCIES_LIMIT)
        currencies.permutation(2).to_a.map do |from, to|
          new(API::BestChange.rates(from, to)).push_to_graph
        end
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
              hash[:currency_from].gsub(/.*RUB.*/, 'RUB')
              .gsub(/.*USD.*/, 'USD')
              .gsub(/.*EUR.*/, 'EUR').to_sym => hash[:amount_from],
              hash[:currency_to].to_sym => hash[:amount_to]
            }
          )
        end
      end
    end
  end
end
