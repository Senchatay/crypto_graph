# frozen_string_literal: true

require 'require_all'
require_all('app/services/**/*.rb')
require_all(Dir.glob('app/models/**/*.rb').reject { |f| f == __FILE__ })

graph = RateToGraph.call
result = graph.find
puts result, graph.nodes
