# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    module BestChange
      URL = 'https://www.bestchange.ru'
      TOP_CHANGERS_COUNT = 5

      module_function

      def call
        %w[bitcoin ethereum tether-erc20 tether-trc20 sberbank].permutation(2).to_a.map do |currency_pair|
          sheet = "#{currency_pair[0]}-to-#{currency_pair[1]}.html"
          response = Faraday.get(URI.join(URL, sheet))
          document = Nokogiri::HTML.parse(response.body)
          parse_from_page(document)
        end
      end

      def parse_from_page(page)
        exchange_names = page.css('.pc').first(TOP_CHANGERS_COUNT)
        pay_from, pay_to = page.css('.bi').first(2 * TOP_CHANGERS_COUNT).to_a.split_by_parity
        exchange_names.each_with_index do |exchange, index|
          amount_from, currency_from = extract_from(pay_from[index].content)
          amount_to, currency_to = extract_from(pay_to[index].content)

          Loader::ChangerLoader.push!(
            exchange.content,
            { currency_from => amount_from, currency_to => amount_to }
          )
        end
      end

      def extract_from(string)
        [
          string.slice!(/[\d. ]*(?= )/).gsub(' ', '_').to_f,
          string[/(?<= )[\w ]*/].to_sym # .gsub(' ', '::')
        ]
      end
    end
  end
end
