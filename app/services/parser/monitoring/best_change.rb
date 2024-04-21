# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    class BestChange
      TOP_CHANGERS_COUNT = 5

      def self.load
        Parser::Monitoring::BestChange::Ru.call
        Parser::Monitoring::BestChange::Com.call
      end

      def self.call
        self::CURRENCYS.permutation(2).to_a.map do |currency_pair|
          sheet = "#{currency_pair[0]}-to-#{currency_pair[1]}.html"
          response = Faraday.get(URI.join(self::URL, sheet))
          document = Nokogiri::HTML.parse(response.body)
          new(document).parse_from_page
        end
      end

      attr_accessor :exchange_names, :pay_from, :pay_to

      def initialize(page)
        @exchange_names = page.css('.pc').first(self.class::TOP_CHANGERS_COUNT)
        @pay_from, @pay_to = page.css('.bi').first(2 * self.class::TOP_CHANGERS_COUNT).to_a.split_by_parity
      end

      def parse_from_page
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
        raise NotImplementedError
      end
    end
  end
end
