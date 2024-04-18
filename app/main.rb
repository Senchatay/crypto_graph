# frozen_string_literal: true

require 'require_all'
require 'byebug'
require_all('app/services/**/*.rb')
require_all('app/models/graph/**/*.rb')
require_all('app/models/exchange/**/*.rb')

board = RateToGraph.call
# result = graph.find
# puts result, graph.nodes
File.write('tmp/result.txt', board.ways_top.join("\n"))
puts board.all_currency
