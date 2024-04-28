# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class SimpleSwap < Base
      MONITORING_NAME = 'simpleswap'
      URL = 'https://api.simpleswap.io'

      def self.load
        # list = exchange_info.map do |info|
        #   {
        #     exchanger: 'simpleswap',
        #     currency_from: info['currency_from'].upcase,  # check case
        #     currency_to: info['currency_to'].upcase,      # check case
        #     amount_from: 1,
        #     amount_to: info['rate'].to_f
        #   }
        # end
        # new(list).push_to_graph
      end

      def self.exchange_info
        response = Faraday.get("#{URL}/get_market_info")
        return [] unless response.success?

        JSON.parse(response.body)
      end
    end
  end
end
