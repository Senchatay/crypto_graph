# frozen_string_literal: true

module Finder
  # Search shortest ways
  module Dijkstra
    def dijkstra_for_node(start)
      distances = {}
      visited = Set.new
      pq = PriorityQueue.new { |a, b| a[:distance] <=> b[:distance] }

      nodes.each do |node|
        distances[node] = Float::INFINITY
      end

      distances[start] = 0
      pq.push(node: start, distance: 0)

      until pq.empty?
        current = pq.pop
        current_node = current[:node]
        visited.add(current_node)
        return distances if visited == nodes

        current_distance = current[:distance]

        net[current_node].each do |neighbor, weight|
          next if visited.include?(neighbor)

          distance = current_distance + weight

          if distance < distances[neighbor]
            distances[neighbor] = distance
            pq.push(node: neighbor, distance:)
          end
        end
      end
    end
  end
end
