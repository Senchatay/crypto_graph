# frozen_string_literal: true

module Loader
  # Mock Data
  module BlockchainCommissionLoader
    # @data = [
    #   Exchange::Commission.new(:'USDT ERC20'),
    #   Exchange::Commission.new(:'USDT TRC20'),
    #   Exchange::Commission.new(:'RUB Сбербанк'),
    #   Exchange::Commission.new(:BTC),
    #   Exchange::Commission.new(:ETH)
    # ].freeze

    module_function

    def find_by(name:)
      commission = data.find { |com| com.name == name }
      return commission if commission

      commission = Exchange::Commission.new(name)
      data << commission
      commission
    end

    def data
      @data ||= []
    end
  end
end
