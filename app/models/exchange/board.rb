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
  end
end
