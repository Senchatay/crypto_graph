# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair.
  module BestExchange
    include Algorithm::DfsWithColors

    START_AMOUNTS = {
      BTC: 0.03,
      BCH: 3,
      TRX: 10_000,
      ETH: 0.5,
      LTC: 18,
      ETC: 53,
      'USDT ERC20': 1500,
      'USDT TRC20': 1500,
      'RUB Сбербанк': 50_000,
      'RUB Тинькофф': 50_000
    }.freeze

    def self.start_amount(currency)
      return @start_amount[currency] if @start_amount

      @start_amount = Hash.new { 1 }
      @start_amount.merge!(START_AMOUNTS)
      @start_amount[currency]
    end

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

    def start_amount(edge)
      Finder::BestExchange.start_amount(edge.first.name)
    end
  end
end
