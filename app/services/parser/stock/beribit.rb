# frozen_string_literal: true

module Parser
  module Stock
    # Stock for loading prices as nodes of graph. Using WebSockets
    class Beribit < Base
      STOCK_NAME = 'beribit.com'
      WS_URL = 'wss://beribit.com/ws/exchange_prices'
      HEADERS = {
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
                        'AppleWebKit/537.36 (KHTML, like Gecko) ' \
                        'Chrome/124.0.0.0 Safari/537.36'
        #   'Sec-WebSocket-Version' => '13',
        #   'Sec-WebSocket-Key' => 'OtzdyLoHvUMGffvjHrYYqw==',
        #   'Sec-WebSocket-Extensions' => 'permessage-deflate; client_max_window_bits'
      }.freeze

      def self.spot_nodes
        spot_info.map do |key, value|
          amount_from = value['ExchangeRate'].to_f
          next if amount_from.zero?

          currency_to, currency_from = key.split('_')

          [
            node(currency_from, currency_to, amount_from:),
            node(currency_to, currency_from, amount_to: amount_from)
          ]
        end.compact.flatten
      end

      def self.spot_info
        response = '{}'
        WebSocket::Client::Simple.connect(WS_URL, headers: HEADERS) do |ws|
          ws.on :open do |_event|
            ws.send('ping')
          end

          ws.on :message do |event|
            response = event.data
            ws.close
          end
        end
        sleep(3)

        JSON.parse(response)
      end
    end
  end
end
