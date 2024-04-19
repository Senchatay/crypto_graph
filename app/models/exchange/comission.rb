# frozen_string_literal: true

module Exchange
  # Comission to deal with transfer
  class Comission
    attr_accessor :name, :cost

    def initialize(name, cost)
      @name = name
      @cost = cost
    end
  end
end
