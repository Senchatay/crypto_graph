# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair. Using algorith dfs https://neerc.ifmo.ru/wiki/index.php?title=%D0%98%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_%D0%BE%D0%B1%D1%85%D0%BE%D0%B4%D0%B0_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83_%D0%B4%D0%BB%D1%8F_%D0%BF%D0%BE%D0%B8%D1%81%D0%BA%D0%B0_%D1%86%D0%B8%D0%BA%D0%BB%D0%B0
  module BestExchange
    attr_accessor :latest_way, :latest_rating, :color, :changeways

    def find_changeways!
      @changeways = Hash.new { |hash, key| hash[key] = Hash.new { |h, k| h[k] = [] } }

      currency_finder.names.each do |name|
        @color = Hash.new { |hash, key| hash[key] = :white }
        @latest_way = [all_targets(name).first[1].source]
        @latest_rating = [1]

        deep_search(name)
      end
      changeways
    end

    private

    def deep_search(name)
      color[name] = :grey
      all_targets(name).each do |currency_name, edge|
        grade_up!(edge)
        if color[currency_name] == :white
          deep_search(currency_name)
        elsif color[currency_name] == :grey
          changeways[currency_name] = {
            way: latest_way.dup,
            cost: latest_rating.dup
          }
        end
        grade_down!
      end
      color[name] = :black
    end

    def grade_up!(edge)
      latest_way.push(edge.target)
      latest_rating.push(edge.distance)
    end

    def grade_down!
      latest_rating.pop
      latest_way.pop
    end
  end
end
