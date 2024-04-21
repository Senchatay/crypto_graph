# frozen_string_literal: true

module Parser
  module Commission
    # Pick LTC commission from web
    module LTC
      URL = 'https://bitinfocharts.com/ru/litecoin/'
      def self.call
        @call ||= begin
          response = Faraday.get(URL)
          document = Nokogiri::HTML.parse(response.body)
          document.at_css('#tdid33').content[/[\d.]*/].to_f
        end
      end
    end
  end
end
