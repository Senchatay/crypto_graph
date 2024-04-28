# frozen_string_literal: true

module Parser
  module Stock
    # Pick BTC commission from web
    class PrimeXBT < Base
      # Telegram bot integration with @MyPrimeXBTbot need to be here, but PrimeXBT not availible in Russia
      RATES = <<~SQL
      SQL
      def self.load
        # list = RATES.split("\n").map do |rate|
        #   next if rate[%r{/}].nil?

        #   currency_from = rate[%r{.*(?=/)}]
        #   currency_to = rate[%r{(?<=/).*(?= )}]
        #   { exchanger: 'PrimeXBT',
        #     currency_from:,
        #     currency_to:,
        #     amount_from: 1,
        #     amount_to: rate[/(?<= )[\d.]*/].to_f }
        # end.compact
        # new(list).push_to_graph
      end
    end
  end
end
