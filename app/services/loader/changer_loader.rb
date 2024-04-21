# frozen_string_literal: true

module Loader
  # Mock Data
  module ChangerLoader
    # @data = [
    #   Exchange::Changer.new('Adb',            [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
    #   Exchange::Changer.new('R2Exchange',     [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
    #   Exchange::Changer.new('GetExch',        [{ 'RUB Сбербанк': 6_169_909.04, 'BTC': 1 }]),
    #   Exchange::Changer.new('GoExme',         [{ 'USDT TRC20': 61_604.0462,    'BTC': 1 }]),
    #   Exchange::Changer.new('CryptoGin',      [{ 'USDT TRC20': 61_642.5029,    'BTC': 1 }]),
    #   Exchange::Changer.new('CoinCraddle',    [{ 'USDT TRC20': 61_665.5875,    'BTC': 1 }]),
    #   Exchange::Changer.new('Crypcie',        [{ 'BTC': 1,                     'USDT TRC20': 63_712.3914 }]),
    #   Exchange::Changer.new('BroExchange',    [{ 'ETH': 1,                     'RUB Сбербанк': 294_547 }]),
    #   Exchange::Changer.new('CryptoPay24',    [{ 'BTC': 1,                     'ETH': 20.900495 }])
    # ].freeze

    module_function

    def push!(name, hash)
      changer = find_by(name:)
      if changer
        changer.exchange_table << hash
      else
        data << Exchange::Changer.new(name, [hash])
      end
      true
    end

    def find_by(name:)
      data.find { |changer| changer.name == name }
    end

    def data
      @data ||= []
    end
  end
end
