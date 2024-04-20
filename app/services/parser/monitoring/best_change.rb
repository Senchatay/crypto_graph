# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    module BestChange
      URL = 'https://www.bestchange.ru/'
      def self.call
        response = Faraday.get(URL)
        JSON.parse(response.body)
      end
    end
  end
end
