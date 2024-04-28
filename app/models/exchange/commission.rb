# frozen_string_literal: true

module Exchange
  # Commission to deal with transfer
  class Commission
    attr_accessor :name, :commission

    def initialize(name)
      @name = name
      @commission = 0
    end
  end
end
