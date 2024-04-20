# frozen_string_literal: true

module Exchange
  # Commission to deal with transfer
  class Commission
    attr_accessor :name, :cost

    def initialize(name, cost)
      @name = name
      @cost = cost
    end
  end
end
