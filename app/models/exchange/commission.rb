# frozen_string_literal: true

module Exchange
  # Commission to deal with transfer
  class Commission
    attr_accessor :name, :commission

    def initialize(name, commission = nil)
      @name = name
      @commission = commission || Object.const_get("Parser::Commission::#{name}Parser").call
    end
  end
end
