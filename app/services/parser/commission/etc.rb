# frozen_string_literal: true

module Parser
  module Commission
    # Pick ETC commission from web
    module ETC
      URL = 'https://bitinfocharts.com/ru/ethereum%20classic/'
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
