# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair.
  module BestExchange
    include Algorithm::DfsWithColors

    attr_accessor :latest_way, :latest_rating, :color, :changeways

    def top_exchange(count)
      find_changeways!
      changeways.map     { |changeway| changeway_data(changeway) }.uniq
                .sort_by { |changeway| -(changeway[:result] / changeway[:way].length) }
                # .sort_by { |changeway| -changeway[:result]       }
                .first(count)
    end

    private

    def changeway_data(changeway)
      amounts = amounts(changeway[:way], changeway[:costs])
      result = (amounts.last - amounts.first) / amounts.first * 100
      {
        way: changeway[:way],
        amounts:,
        result:
      }
    end

    def amounts(edges, costs)
      amounts = [start_amount(edges.first)]
      costs.each_with_index do |cost, index|
        current_edge = edges[index]
        amounts << take_commission(amounts.last, cost, current_edge.first)
      end
      amounts
    end

    def take_commission(amount, rating, node)
      return 0 unless amount.positive?

      commission = Loader::BlockchainCommissionLoader.find_by(name: node.name).commission
      amount *= 0.9 if node.changer.name == 'simpleswap'
      return 0 unless amount > commission

      rating * (amount - commission)
    end

    def start_amount(edge)
      Loader::AmountLoader.start_amount(edge.first.name)
    end
  end
end
