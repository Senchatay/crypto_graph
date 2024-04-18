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

    def ways_top
      find_changeways!
      changeways.map do |changeway|
        way = changeway[:way].map(&:full_name).join(' -> ')
        cost = changeway[:cost].reduce(&:*)
        "#{way}; #{cost}"
      end
    end

    def all_targets(name)
      @all_targets[name] ||=
        (currency_finder.names - [name]).map do |currency_name|
          edges_to_targets = edges.select do |edge|
            edge.source.name == name && edge.target.name == currency_name
          end
          next if edges_to_targets.empty?

          shortest_edge = edges_to_targets.min { |a, b| a.distance <=> b.distance }

          [currency_name, shortest_edge]
        end.compact
    end
  end
end
