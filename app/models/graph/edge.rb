# frozen_string_literal: true

module Graph
  # Gparh Edge is exchange cost
  class Edge
    attr_accessor :source, :target, :distance

    def initialize(source, target, distance)
      @source = source
      @target = target
      @distance = distance
    end
  end
end
