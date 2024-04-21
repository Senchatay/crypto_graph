# frozen_string_literal: true

module Parser
  module Monitoring
    class BestChange
      # Pick BestChange.com exchanges
      class Com < ::Parser::Monitoring::BestChange
        URL = 'https://www.bestchange.com'
        CURRENCYS = %w[bitcoin ethereum tether-erc20 tether-trc20 tron bitcoin-cash].freeze

        def extract_from(string)
          [
            string.slice!(/[\d. ]*(?= )/).gsub(' ', '_').to_f,
            (string[/(?<= ).*(?=min)/] || string[/(?<= ).*/]).to_sym # .gsub(' ', '::')
          ]
        end
      end
    end
  end
end
