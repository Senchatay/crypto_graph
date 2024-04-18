# frozen_string_literal: true

# Present rates as graph
class RateToGraph
  SAME_CURRENCY_EDGE_DISTANCE = 1

  attr_accessor :changers

  def self.call
    changers = [
      Exchange::Changer.new('Adb',            [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
      Exchange::Changer.new('R2Exchange',     [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
      Exchange::Changer.new('GetExch',        [{ 'RUB Сбербанк': 6_169_909.04, 'BTC': 1 }]),
      Exchange::Changer.new('GoExme',         [{ 'USDT TRC20': 61_604.0462,    'BTC': 1 }]),
      Exchange::Changer.new('CryptoGin',      [{ 'USDT TRC20': 61_642.5029,    'BTC': 1 }]),
      Exchange::Changer.new('CoinCraddle',    [{ 'USDT TRC20': 61_665.5875,    'BTC': 1 }]),
      Exchange::Changer.new('Crypcie',        [{ 'BTC': 1,                     'USDT TRC20': 63_712.3914 }]),
      Exchange::Changer.new('BroExchange',    [{ 'ETH': 1,                     'RUB Сбербанк': 294_547 }])
    ]
    new(changers).call
  end

  def initialize(changers)
    @changers = changers
  end

  def call
    edges = edges_constructor
    Exchange::Board.new(edges)
  end

  def edges_constructor
    different_currency + same_currency
  end

  def different_currency
    @different_currency ||=
      changers.map do |changer|
        changer.exchange_table.map do |exchage_pair|
          source = Graph::Node.new(exchage_pair.keys[0], changer)
          target = Graph::Node.new(exchage_pair.keys[1], changer)
          distance = exchage_pair.values[1] / exchage_pair.values.first

          Graph::Edge.new(source, target, distance)
        end
      end.flatten
  end

  def same_currency
    edges = different_currency

    nodes = edges.map(&:source) + edges.map(&:target)

    Finder::NodeByName.all(nodes).values.map do |same_currency_nodes|
      same_currency_nodes.permutation(2).map do |source, target|
        Graph::Edge.new(source, target, SAME_CURRENCY_EDGE_DISTANCE)
      end
    end.flatten
  end
end
