# frozen_string_literal: true

module Loader
  # Mock Data
  module BlockchainCommissionLoader
    DATA = [
      Exchange::Commission.new(:'USDT TRC20', 0.01),
      Exchange::Commission.new(:'RUB Сбербанк', 0.01),
      Exchange::Commission.new(:BTC, 0.01),
      Exchange::Commission.new(:ETH, 0.01)
    ].freeze

    def self.find_by(name:)
      DATA.find { |commission| commission.name == name }
    end
  end
end
