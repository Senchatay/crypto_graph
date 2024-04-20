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
        header!(f)
        ways_top!(f)
      end
      puts board.all_currency
    end

    private

    def header!(file)
      string = "|#{'Currency from'.center(25)}|#{'Count'.center(25)}|"
      string += ''.center(25)
      string += "|#{'Currency to'.center(25)}|#{'Count'.center(25)}|\n"
      file.write(string)
    end

    def split_line!(file)
      file.write('-' * 131)
      file.write("\n")
    end

    def ways_top!(file)
      board.top_exchange(TOP_LIMIT).map do |changeway|
        split_line!(file)
        print_changeway!(file, **changeway)
      end
    end

    def print_changeway!(file, way:, amounts:, result:)
      print_each_edge!(file, way, amounts)
      split_line!(file)
      file.write("#{result}%")
      file.write("\n")
      file.write("\n")
    end

    def print_each_edge!(file, way, amounts)
      way.each_with_index do |edge, index|
        file.write(
          changeway_as_string(
            edge.first.full_name.to_s,
            amounts[index].to_s,
            edge.last.full_name.to_s,
            amounts[index + 1].to_s
          )
        )
      end
    end

    def changeway_as_string(currency_from, count_from, currency_to, count_to)
      string = "|#{currency_from.ljust(25)}|#{count_from.ljust(25)}|"
      string += '==>'.center(25)
      string += "|#{currency_to.ljust(25)}|#{count_to.ljust(25)}|\n"
      string
    end
  end
end
