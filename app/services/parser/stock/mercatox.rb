# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class Mercatox < Base
      STOCK_NAME = 'mercatox.com'
      API_URL = 'https://mercatox.com/api/public/v1/ticker'

      def self.spot_nodes
        # spot_info.map do |symbol, info|
        #   currency_from, currency_to = symbol.split('_')
        #   amount_from, amount_to = info.values_at('lowestAsk', 'highestBid').map(&:to_f)
        #   next if [amount_from, amount_to].any?(&:zero?)

        #   [
        #     node(currency_from, currency_to, amount_to:),
        #     node(currency_to, currency_from, amount_from:)
        #   ]
        # end.compact.flatten
        []
      end

      def self.spot_info
        response = Faraday.get(API_URL)
        return [] unless response.success?

        JSON.parse(response.body)
      end
    end
  end
end
