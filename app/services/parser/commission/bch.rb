# frozen_string_literal: true

module Parser
  module Commission
    # Pick BCH commission from web
    module BCH
      URL = 'https://bitinfocharts.com/ru/bitcoin%20cash/'
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
