# frozen_string_literal: true

# Helps dijkstra to calculate best way
class PriorityQueue
  attr_accessor :heap, :comparator

  def initialize(&cmp)
    @heap = []
    @comparator = cmp
  end

  def push(element)
    heap << element
    heap.sort! { |a, b| comparator.call(a, b) }
  end

  def pop
    heap.shift
  end

  def empty?
    heap.empty?
  end
end
