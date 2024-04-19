# frozen_string_literal: true

module Loader
  # Mock Data
  module BlockchainComissionLoader
    DATA = [
      Exchange::Comission.new(:'USDT TRC20', 0.01),
      Exchange::Comission.new(:'RUB Сбербанк', 0.01),
      Exchange::Comission.new(:BTC, 0.01),
      Exchange::Comission.new(:ETH, 0.01)
    ].freeze

    def self.find_by(name:)
      DATA.find { |comission| comission.name == name }
    end
  end
end
