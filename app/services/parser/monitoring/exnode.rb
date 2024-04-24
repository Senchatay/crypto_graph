# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    module Exnode
      URL = 'https://exnode.ru/-courses-/api/v2/rates'
      CURRENCYS = %w[ETH BTC USDTTRC USDTERC TRX SBERRUB SBPRUB TCSBRUB LTC BCH ETC SOL BNB TON].freeze
      TOP_EXCHANGER_LIMIT = 3

      module_function

      def load
        connection = Faraday.new(url: URL)
        begin
          CURRENCYS.permutation(2).to_a.map do |currency_pair|
            response = connection.get('', { from: currency_pair[0], to: currency_pair[1] })
            document = JSON.parse(response.body)
            parse_from_page(document)
          end
        rescue Faraday::Error => e
          puts e
        ensure
          connection.close
        end
      end

      def parse_from_page(page)
        items = page['items']&.first(TOP_EXCHANGER_LIMIT)
        items&.each do |item|
          currency_from = prepare_currency(item['from_currency'])
          currency_to = prepare_currency(item['to_currency'])
          next if currency_from == currency_to

          Loader::ChangerLoader.push!(
            item['exchanger']['name'],
            {
              currency_from => item['in'].to_f,
              currency_to => item['out'].to_f
            },
            site: item['exchanger']['url_site']
          )
        end
      end

      def prepare_currency(currency)
        currency.gsub('USDT', 'USDT ').gsub(/.*RUB.*/, 'RUB').to_sym
      end
    end
  end
end
