# frozen_string_literal: true

module Parser
  module Stock
    # Pick exnode.ru exchanges
    class BitFinex < Base
      STOCK_NAME = 'bitfinex.com'
      URL = 'https://api-pub.bitfinex.com/v2/tickers?symbols=ALL'

      # Needs address documents for verification
      def self.load; end

      def self.spot_nodes
        # stock_info.map do |info|
        #   pair = info[0][/(?<=t).*/]
        #   if pair.include?(':')
        #     currency_from, currency_to = pair.split(':')
        #   else
        #     currency_from = pair[...3]
        #     currency_to = pair[-3...]
        #   end
        #   amount_bid = info[1]
        #   amount_ask = info[3]
        #   next if [amount_from, amount_to].any?(&:zero?)

        #   [
        #     node(currency_from, currency_to, amount_to: amount_bid),
        #     node(currency_to, currency_from, amount_from: amount_ask)
        #   ]
        # end.compact.flatten
      end

      def self.stock_info
        response = Faraday.get("#{URL}/market/tickers?category=spot")
        return [] unless response.success?

        JSON.parse(response.body)
      end
    end
  end
end
