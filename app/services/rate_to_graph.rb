# frozen_string_literal: true

# Present rates as graph
class RateToGraph
  SAME_CURRENCY_EDGE_DISTANCE = 1

  attr_accessor :changers

  def self.call
    Loader::PricesLoader.call
    new(Loader::ChangerLoader.data).call
  end

  def initialize(changers)
    @changers = changers
  end

  def call
    @board = Exchange::Board.new
    @board.edges = edges_constructor
    @board.nodes = Loader::NodeLoader.data
    @board
  end

  def edges_constructor
    different_currency #+ same_currency
  end

  def different_currency
    changers.map do |changer|
      changer.exchange_table.map do |exchage_pair|
        source = Loader::NodeLoader.push!(exchage_pair.keys[0], changer)
        target = Loader::NodeLoader.push!(exchage_pair.keys[1], changer)
        distance = exchage_pair.values[1] / exchage_pair.values.first

        Graph::Edge.new(source, target, distance)
      end
    end.flatten
  end

  # def same_currency
  #   @board.currency_finder.nodes_by_name.values.map do |same_currency_nodes|
  #     same_currency_nodes.permutation(2).map do |source, target|
  #       Graph::Edge.new(source, target, SAME_CURRENCY_EDGE_DISTANCE)
  #     end
  #   end.flatten
  # end
end
