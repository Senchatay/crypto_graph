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
        changeway.map(&:full_name).join(' -> ')
      end
    end

    def all_targets(node)
      same_nodes = Finder::NodeByName.with_other_exchange(nodes, node)
      edges.select { |edge| same_nodes.include?(edge.source) && !same_nodes.include?(edge.target) }.map(&:target)
    end
  end
end
