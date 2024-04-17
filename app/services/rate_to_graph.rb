# frozen_string_literal: true

# Present rates as graph
module RateToGraph
  def self.call
    changers = [
      Changer.new('Adb',            [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
      Changer.new('R2Exchange',     [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
      Changer.new('GetExch',        [{ 'RUB Сбербанк': 6_169_909.04, 'BTC': 1 }]),
      Changer.new('GoExme',         [{ 'USDT TRC20': 61_604.0462,    'BTC': 1 }]),
      Changer.new('CryptoGin',      [{ 'USDT TRC20': 61_642.5029,    'BTC': 1 }]),
      Changer.new('CoinCraddle',    [{ 'USDT TRC20': 61_665.5875,    'BTC': 1 }])
    ]
    edges = edges_constructor(changers)

    Graph::Graph.new(edges)
  end

  def self.edges_constructor(changers)
    currency_tables = changers.map(&:exchange_table)
    currency_tables.map do |table|
      table.map do |exchage_pair|
        source = exchage_pair.keys.first
        target = exchage_pair.keys[1]
        distance = exchage_pair.values[1] / exchage_pair.values.first

        Graph::Edge.new(source, target, distance)
      end
    end.flatten
  end
end
