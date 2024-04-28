# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    class BestChange
      CURRENCYS = ['ETH', 'BTC', 'USDT TRC20', 'USDT ERC20', 'TRX', 'LTC', 'BCH', 'ETC', 'SOL', 'BNB', 'TON'].freeze

      def self.load
        # API::BestChange.currencies.values
        # CURRENCYS.permutation(2).to_a.map do |from, to|
        #   new(API::BestChange.rates(from, to)).push_to_graph
        # end
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
              hash[:currency_from].gsub(/.*RUB.*/, 'RUB').to_sym => hash[:amount_from],
              hash[:currency_to].to_sym => hash[:amount_to]
            }
          )
        end
      end
    end
  end
end
