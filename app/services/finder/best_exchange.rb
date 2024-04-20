# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair.
  module BestExchange
    include Algorithm::DfsWithColors

    START_AMOUNT = 20

    attr_accessor :latest_way, :latest_rating, :color, :changeways

    def top_exchange(count)
      find_changeways!
      changeways.map     { |changeway| changeway_data(changeway) }
                .sort_by { |changeway| -changeway[:result]       }
                .first(count)
    end

    private

    def changeway_data(changeway)
      amounts = amounts(changeway[:way], changeway[:costs])
      result = (amounts.last - START_AMOUNT) / START_AMOUNT * 100
      {
        way: changeway[:way],
        amounts:,
        result:
      }
    end

    def amounts(edges, costs)
      amounts = [START_AMOUNT]
      costs.each_with_index do |cost, index|
        current_edge = edges[index]
        amounts << take_commission(amounts.last, cost, current_edge.first.name)
      end
      amounts
    end

    def take_commission(amount, rating, currency)
      return 0 unless amount.positive?

      commission = Loader::BlockchainCommissionLoader.find_by(name: currency).commission
      return 0 unless amount > commission

      rating * (amount - commission)
    end
  end
end
