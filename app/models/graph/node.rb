# frozen_string_literal: true

module Graph
  # Gparh Node is currency
  class Node
    attr_accessor :name, :chnager

    def initialize(name, chnager)
      @name = name
      @chnager = chnager
    end
  end
end
