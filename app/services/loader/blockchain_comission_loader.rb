# frozen_string_literal: true

module Loader
  # Mock Data
  module BlockchainCommissionLoader
    DATA = [
      Exchange::Commission.new(:'USDT TRC20'),
      Exchange::Commission.new(:'RUB Сбербанк'),
      Exchange::Commission.new(:BTC),
      Exchange::Commission.new(:ETH)
    ].freeze

    def self.find_by(name:)
      DATA.find { |commission| commission.name == name }
    end
  end
end
