# frozen_string_literal: true

module Exchange
  # Changer means Crypto Changer that will be parse
  class Changer
    attr_accessor :name, :exchange_table

    def initialize(name, exchange_table)
      @name = name
      @exchange_table = exchange_table
    end
  end
end
