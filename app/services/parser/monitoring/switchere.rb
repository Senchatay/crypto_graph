# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class Switchere < Base
      MONITORING_NAME = 'switchere.com'
      URL = 'https://switchere.com/api/v2/public/ticker'
      MAPPING = {
        'USDT20' => :'USDT ERC20',
        'USDTTRC20' => :'USDT TRC20'
      }.freeze

      def self.exchange_nodes
        exchange_info.map do |info|
          currency_from, currency_to = info['name'].split('-')
          currency_from = MAPPING[currency_from] if MAPPING.key?(currency_from)
          currency_to = MAPPING[currency_to] if MAPPING.key?(currency_to)
          [
            node(currency_from, currency_to, amount_to: info['bid'].to_f),
            node(currency_to, currency_from, amount_from: info['ask'].to_f)
          ]
        end.flatten
      end

      def self.exchange_info
        response = Faraday.get(URL)
        return [] unless response.success?

        JSON.parse(response.body)
      end
    end
  end
end
