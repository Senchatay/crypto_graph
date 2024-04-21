# frozen_string_literal: true

module Loader
  # Mock Data
  module MonitoringLoader
    module_function

    def call
      Parser::Monitoring.constants.each do |resource|
        Parser::Monitoring.const_get(resource).load
      end
    end
  end
end
