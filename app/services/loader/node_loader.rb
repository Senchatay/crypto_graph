# frozen_string_literal: true

module Loader
  # Mock Data
  module NodeLoader
    # @data = [
    #   Graph::Node.new('Adb',            [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
    #   Graph::Node.new('R2Exchange',     [{ 'USDT TRC20': 1,              'RUB Сбербанк': 97.32 }]),
    #   Graph::Node.new('GetExch',        [{ 'RUB Сбербанк': 6_169_909.04, 'BTC': 1 }]),
    #   Graph::Node.new('GoExme',         [{ 'USDT TRC20': 61_604.0462,    'BTC': 1 }]),
    #   Graph::Node.new('CryptoGin',      [{ 'USDT TRC20': 61_642.5029,    'BTC': 1 }]),
    #   Graph::Node.new('CoinCraddle',    [{ 'USDT TRC20': 61_665.5875,    'BTC': 1 }]),
    #   Graph::Node.new('Crypcie',        [{ 'BTC': 1,                     'USDT TRC20': 63_712.3914 }]),
    #   Graph::Node.new('BroExchange',    [{ 'ETH': 1,                     'RUB Сбербанк': 294_547 }]),
    #   Graph::Node.new('CryptoPay24',    [{ 'BTC': 1,                     'ETH': 20.900495 }])
    # ].freeze

    module_function

    def push!(name, changer)
      node = Graph::Node.new(name, changer)
      exist_node = find_by(full_name: node.full_name)
      return exist_node if exist_node

      data << node
      node
    end

    def find_by(full_name:)
      data.find { |node| node.full_name == full_name }
    end

    def data
      @data ||= Set.new
    end

    def clear!
      @data = Set.new
    end
  end
end
