# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick BTC commission from web
    class Exmo
      URL = 'https://api.exmo.com/v1.1/ticker'
      def self.load
        list = JSON.parse(Faraday.get(URL).body).map do |pair, info|
          currency_to, currency_from = pair.split('_').split_by_parity
          currency_from = ['USDT ERC20', 'USDT TRC20'] if currency_from == 'USDT'
          currency_to = ['USDT ERC20', 'USDT TRC20'] if currency_to == 'USDT'
          currency_from.map do |from|
            currency_to.map do |to|
              [
                node(from, to, amount_from: info['sell_price'].to_f),
                node(to, from, amount_to: info['buy_price'].to_f)
              ]
            end
          end
        end.flatten
        new(list).push_to_graph
      end

      def self.node(currency_from, currency_to, amount_from: 1, amount_to: 1)
        {
          exchanger: 'exmo.me',
          currency_from:,
          currency_to:,
          amount_from:,
          amount_to:
        }
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
