# frozen_string_literal: true

module Graph
  # Gparh Node is currency
  class Node
    attr_accessor :name, :changer

    def initialize(name, changer)
      @name = name
      @changer = changer
    end

    def full_name
      "#{changer.name}::#{name}"
    end
  end
end
