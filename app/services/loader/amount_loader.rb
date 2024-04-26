# frozen_string_literal: true

module Loader
  # Mock Data
  module AmountLoader
    START_AMOUNTS = {
      BTC: 0.03,
      BCH: 3,
      TRX: 10_000,
      ETH: 0.5,
      LTC: 18,
      ETC: 53,
      SOL: 10,
      'USDT ERC20': 1500,
      'USDT TRC20': 1500,
      'RUB': 50_000
    }.freeze

    module_function

    def start_amount(currency)
      return @start_amount[currency] if @start_amount

      @start_amount = Hash.new { 10 }
      @start_amount.merge!(START_AMOUNTS)
      @start_amount[currency]
    end
  end
end
