# frozen_string_literal: true

module Exchange
  # Board is tab with prices
  class Board < ::Graph::Graph
    include ::Finder::BestExchange

    def initialize
      @all_targets = {}
      super
    end

    def currency_finder
      @currency_finder ||= Finder::Currency.new(nodes)
    end

    def all_currency
      nodes.map(&:full_name)
    end

    def ways(from, to)
      edges.select do |edge|
        edge.source.name == from && edge.target.name == to
      end
    end

    def all_targets(name)
      @all_targets[name] ||=
        currency_finder.names(name).filter_map do |currency_name|
          edges_to_targets = ways(name, currency_name)
          next if edges_to_targets.empty?

          shortest_edge = edges_to_targets.min { |a, b| a.distance <=> b.distance }

          [currency_name, shortest_edge]
        end
    end
  end
end
