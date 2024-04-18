# frozen_string_literal: true

module Exchange
  # Board is tab with prices
  class Board < ::Graph::Graph
    include ::Finder::BestExchange

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

    def all_targets(node)
      same_nodes = Finder::NodeByName.with_other_exchange(nodes, node)
      edges_to_targets = edges.select do |edge|
        same_nodes.include?(edge.source) && !same_nodes.include?(edge.target)
      end
      edges_to_targets.map do |edge|
        [edge.target, edge.distance]
      end
    end
  end
end
