# frozen_string_literal: true

module Parser
  module Monitoring
    # Pick exnode.ru exchanges
    class OneInch
      URL = 'https://api.1inch.dev'

      def self.load
        @connection = Faraday.new(url: URL)
        begin
          new(exchange_info).push_to_graph
        rescue Faraday::Error => e
          puts e
        ensure
          @connection.close
        end
      end

      def self.exchange_info
        [1, 56, 137].map do |chain|
          price_hash = prices(chain)
          sleep(1)
          tokens(chain).permutation(2).first(::Loader::PricesLoader::NODES_LIMIT).map do |pair|
            amount_from = Loader::AmountLoader.from_wei(
              price_hash[pair[0]['address']]
            )
            amount_to = Loader::AmountLoader.from_wei(
              price_hash[pair[1]['address']]
            )
            next if [amount_from, amount_to].any?(&:zero?)

            [
              node(chain, pair[1]['symbol'], pair[0]['symbol'], amount_from:, amount_to:),
              node(
                chain,
                pair[0]['symbol'],
                pair[1]['symbol'],
                amount_from: amount_to,
                amount_to: amount_from
              )
            ]
          end.compact
        end.flatten
      end

      def self.prices(chain = 1)
        response = request("/price/v1.1/#{chain}")
        return {} unless response.success?

        JSON.parse(response.body)
      end

      def self.tokens(chain = 1)
        response = request("/swap/v6.0/#{chain}/tokens")
        return {} unless response.success?

        JSON.parse(response.body)['tokens'].values.map do |token|
          token.slice('symbol', 'address', 'decimals')
        end
      end

      def self.request(path, params = {})
        @connection.get(
          path,
          params,
          { 'Authorization': ENV['1INCH_API_KEY'] }
        )
      end

      def self.node(chain, currency_from, currency_to, amount_from:, amount_to:)
        {
          exchanger: "app.1inch.io::#{chain}",
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
