# frozen_string_literal: true

module Graph
  # Mathematic Graph
  class Graph
    include ::Finder::BestExchange
    # include ::Finder::Dijkstra

    attr_accessor :edges, :net, :nodes

    def initialize(edges)
      @edges = edges
      @nodes = Set.new
      @net = Hash.new { |hash, key| hash[key] = {} }
      build_net!
    end

    def build_net!
      edges.each do |edge|
        net[edge.source][edge.target] = edge.distance
        nodes.add(edge.source)
        nodes.add(edge.target)
      end
    end

    def all_targets(node)
      edges.select { |edge| edge.source == node }.map(&:target)
    end
  end
end
