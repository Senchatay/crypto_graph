# frozen_string_literal: true

module Loader
  # Mock Data
  module BlockchainCommissionLoader
    DATA = [
      Exchange::Commission.new(:'USDT TRC20', 0),
      Exchange::Commission.new(:'RUB Сбербанк', 0),
      Exchange::Commission.new(:BTC),
      Exchange::Commission.new(:ETH, 0)
    ].freeze

    def self.find_by(name:)
      DATA.find { |commission| commission.name == name }
    end
  end
end
