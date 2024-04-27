# frozen_string_literal: true

module Loader
  # Mock Data
  module PricesLoader
    NODES_LIMIT = 100

    module_function

    def call
      monitorin_threads = Parser::Monitoring.constants.map do |resource|
        Thread.new { Parser::Monitoring.const_get(resource).load }
      end
      stock_threads = (Parser::Stock.constants - [:Base]).map do |resource|
        Thread.new { Parser::Stock.const_get(resource).load }
      end
      (monitorin_threads + stock_threads).each(&:join)
    end
  end
end
