# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    class PrimeXBT
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

      attr_accessor :list

      def initialize(list)
        @list = list
      end

      def push_to_graph
        list.each do |hash|
          Loader::ChangerLoader.push!(
            hash[:exchanger],
            {
              hash[:currency_from].to_sym => hash[:amount_from],
              hash[:currency_to].to_sym => hash[:amount_to]
            }
          )
        end
      end
    end
  end
end
