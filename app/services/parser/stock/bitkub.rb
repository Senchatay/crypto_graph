# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph
    class Bitkub < Base
      STOCK_NAME = 'bitkub.com'
      API_URL = 'https://api.bitkub.com/api/market/ticker'

      def self.spot_nodes
        # spot_info.map do |_symbol, info|
        #   currency_from, currency_to = info['name'].split('/')
        #   amount_from, amount_to = info.values_at('sell', 'buy').map(&:to_f)
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

        JSON.parse(response.body)['data']
      end
    end
  end
end
