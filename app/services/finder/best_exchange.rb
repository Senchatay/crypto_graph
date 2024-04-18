# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair. Using algorith dfs https://neerc.ifmo.ru/wiki/index.php?title=%D0%98%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_%D0%BE%D0%B1%D1%85%D0%BE%D0%B4%D0%B0_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83_%D0%B4%D0%BB%D1%8F_%D0%BF%D0%BE%D0%B8%D1%81%D0%BA%D0%B0_%D1%86%D0%B8%D0%BA%D0%BB%D0%B0
  module BestExchange
    attr_accessor :latest_way, :color, :changeways

    def find
      @changeways = []
      @color = Hash.new { |hash, key| hash[key] = :white }
      remaining_nodes = nodes.to_a

      until remaining_nodes.empty?
        current_node = remaining_nodes.shift
        @latest_way = [current_node]

        deep_search(current_node)
        remaining_nodes -= color.keys
      end
      changeways
    end

    private

    def deep_search(current_node)
      color[current_node] = :grey
      all_targets(current_node).each do |node|
        latest_way.push(node)

        if color[node] == :white
          deep_search(node)
        elsif color[node] == :grey
          changeways << "Current way: #{latest_way}"
        end

        latest_way.pop
      end
      color[current_node] = :black
    end
  end
end
