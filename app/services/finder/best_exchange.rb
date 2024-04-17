# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair
  module BestExchange
    def self.call(currency1, currency2); end

    def best_exchange(start_node, start_cost)
      distances = {}
      visited = Set.new
      pq = PriorityQueue.new { |a, b| a[:distance] <=> b[:distance] }

      nodes.each do |node|
        distances[node] = Float::INFINITY
      end

      distances[start_node] = start_cost
      pq.push(node: start_node, distance: start_cost)

      until pq.empty?
        current = pq.pop
        current_node = current[:node]
        visited.add(current_node)
        return distances if visited == nodes

        current_distance = current[:distance]

        net[current_node].each do |neighbor, weight|
          next if visited.include?(neighbor)

          distance = current_distance * weight

          if distance < distances[neighbor]
            distances[neighbor] = distance
            pq.push(node: neighbor, distance:)
          end
        end
      end
    end
  end
end
