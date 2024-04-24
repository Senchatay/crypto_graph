# frozen_string_literal: true

module Algorithm
  # Using algorith dfs with colorize. Chech README.md
  module DfsWithColors
    MAX_CHANGE_LENGTH = 6

    private

    def find_changeways!
      @changeways = []

      currency_finder.names.each do |name|
        @color = Hash.new { |hash, key| hash[key] = :white }
        @latest_way = []
        @latest_rating = []

        deep_search(name)
      end
      changeways
    end

    def deep_search(name)
      color[name] = :grey
      all_targets(name).each do |currency_name, edge|
        grade_up!(edge)
        if color[currency_name] == :white
          deep_search(currency_name)
        elsif color[currency_name] == :grey
          save_result!(edge)
        end
        grade_down!
      end
      color[name] = :black
    end

    def grade_up!(edge)
      latest_way.push([edge.source, edge.target])
      latest_rating.push(edge.distance)
    end

    def grade_down!
      latest_rating.pop
      latest_way.pop
    end

    def save_result!(edge)
      index = latest_way.index { |nodes| currency_finder.with_other_exchange(edge.target).include?(nodes.first) }
      way = latest_way.dup[index..]
      return if way.length > MAX_CHANGE_LENGTH

      costs = latest_rating.dup[index..]
      changeways << {
        way:,
        costs:
      }
    end
  end
end
