# frozen_string_literal: true

module Presenter
  # Present resultst in tmp/result.txt
  class TxtResult
    attr_accessor :board

    def self.call(board)
      new(board).call
    end

    def initialize(board)
      @board = board
    end

    def call
      File.write('tmp/result.txt', ways_top.join("\n\n"))
      puts board.all_currency
    end

    private

    def ways_top
      board.find_changeways!
      board.changeways.dup.map do |changeway|
        perform_as_string(*changeway.values_at(:way, :cost))
      end
    end

    def perform_as_string(ways, costs)
      strings = []
      coefficient = 1
      ways.each_with_index do |way, index|
        prev_coefficient = coefficient
        coefficient *= costs[index]
        strings << way.first.full_name.to_s.ljust(25)
        strings << "(#{prev_coefficient})".ljust(25)
        strings << '==>'.center(25)
        strings << way.last.full_name.to_s.ljust(25)
        strings << "(#{coefficient});\n"
      end
      strings << "#{(coefficient - 1) * 100}%"
      strings.join
    end
  end
end
