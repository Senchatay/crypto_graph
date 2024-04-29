# frozen_string_literal: true

module Loader
  # Mock Data
  module PricesLoader
    NODES_LIMIT = 400

    module_function

    def call
      threads = threads(Parser::Monitoring) + threads(Parser::Stock)
      threads.each(&:join)
    end

    def threads(directory)
      (directory.constants - [:Base]).map do |resource|
        Thread.new { directory.const_get(resource).load }
      end
    end
  end
end
