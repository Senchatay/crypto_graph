# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair. Using algorith dfs https://neerc.ifmo.ru/wiki/index.php?title=%D0%98%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_%D0%BE%D0%B1%D1%85%D0%BE%D0%B4%D0%B0_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83_%D0%B4%D0%BB%D1%8F_%D0%BF%D0%BE%D0%B8%D1%81%D0%BA%D0%B0_%D1%86%D0%B8%D0%BA%D0%BB%D0%B0
  module BestExchange
    attr_accessor :latest_way, :latest_rating, :color, :changeways

    def find_changeways!
      @changeways = []
      @color = Hash.new { |hash, key| hash[key] = :white }
      remaining_nodes = nodes.to_a

      until remaining_nodes.empty?
        current_node = remaining_nodes.shift
        @latest_way = [current_node]
        @latest_rating = [1]

        deep_search(current_node)
        remaining_nodes -= color.keys
      end
      changeways
    end

    private

    def deep_search(current_node)
      Finder::NodeByName.with_other_exchange(nodes, current_node).each do |node|
        color[node] = :grey
      end
      all_targets(current_node).each do |node, distance|
        grade_up!(node, distance)
        if color[node] == :white
          deep_search(node)
        elsif color[node] == :grey
          changeways << { way: latest_way.dup, cost: latest_rating.dup }
        end
        grade_down!
      end
      color[current_node] = :black
    end

    def grade_up!(node, distance)
      latest_way.push(node)
      latest_rating.push(distance)
    end

    def grade_down!
      latest_rating.pop
      latest_way.pop
    end
  end
end
