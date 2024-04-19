# frozen_string_literal: true

module Presenter
  # Present resultst in tmp/result.txt
  class TxtResult
    TOP_LIMIT = 5

    attr_accessor :board

    def self.call(board)
      new(board).call
    end

    def initialize(board)
      @board = board
    end

    def call
      Dir.mkdir 'tmp' unless Dir.exist?('tmp')
      File.open('tmp/result.txt', 'w+') do |f|
        f.write(ways_top.join("\n\n"))
      end
      puts board.all_currency
    end

    private

    def ways_top
      board.top_exchange(TOP_LIMIT).map do |changeway|
        perform_as_string(**changeway)
      end
    end

    def perform_as_string(way:, coefficients:, result:)
      strings = []
      way.each_with_index do |edge, index|
        strings << edge.first.full_name.to_s.ljust(25)
        strings << "(#{coefficients[index]})".ljust(25)
        strings << '==>'.center(25)
        strings << edge.last.full_name.to_s.ljust(25)
        strings << "(#{coefficients[index + 1]});\n"
      end
      strings << "#{result}%"
      strings.join
    end
  end
end
