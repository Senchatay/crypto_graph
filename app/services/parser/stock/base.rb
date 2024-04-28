# frozen_string_literal: true

module Parser
  module Stock
    # Interface for Stock classes
    class Base
      def self.load
        list = spot_nodes.first(::Loader::PricesLoader::NODES_LIMIT) + p2p_nodes
        new(list).push_to_graph
      end

      def self.spot_nodes
        []
      end

      def self.p2p_nodes
        []
      end

      def self.node(currency_from, currency_to, amount_from: 1, amount_to: 1)
        {
          exchanger: self::STOCK_NAME,
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
          from = hash[:currency_from].to_sym
          to = hash[:currency_to].to_sym
          next if [from, to].any? { |currency| ::Finder::Currency::EXCEPTED_CURRENCY.include?(currency) }

          Loader::ChangerLoader.push!(
            hash[:exchanger],
            {
              from => hash[:amount_from],
              to => hash[:amount_to]
            }
          )
        end
      end
    end
  end
end
