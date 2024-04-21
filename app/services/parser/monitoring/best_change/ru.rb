# frozen_string_literal: true

module Parser
  module Monitoring
    class BestChange
      # Pick BestChange.ru exchanges
      class Ru < ::Parser::Monitoring::BestChange
        URL = 'https://www.bestchange.ru'
        CURRENCYS = %w[bitcoin ethereum tether-erc20 tether-trc20 sberbank tinkoff].freeze

        def extract_from(string)
          [
            string.slice!(/[\d. ]*(?= )/).gsub(' ', '_').to_f,
            (string[/(?<= ).*(?=от)/] || string[/(?<= ).*/]).to_sym # .gsub(' ', '::')
          ]
        end
      end
    end
  end
end
