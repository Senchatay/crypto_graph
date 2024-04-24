# frozen_string_literal: true

module Presenter
  # Present resultst in tmp/result.txt
  class TxtResult
    TOP_LIMIT = 10

    attr_accessor :board, :top

    def self.call(board)
      new(board).call
    end

    def initialize(board)
      @board = board
      @top = board.top_exchange(TOP_LIMIT)
    end

    def call
      Dir.mkdir 'tmp' unless Dir.exist?('tmp')
      File.open('tmp/result.txt', 'w+') do |f|
        header!(f)
        ways_top!(f)
        currencys!(f)
      end
      true
    end

    private

    def header!(file)
      string = "|#{"Time: #{Time.now}".center(131)}|\n"
      string += "|#{'Currency from'.center(25)}|#{'Count'.center(25)}|"
      string += '==>'.center(25)
      string += "|#{'Currency to'.center(25)}|#{'Count'.center(25)}|\n"
      file.write(string)
    end

    def split_line!(file)
      file.write('-' * 131)
      file.write("\n")
    end

    def ways_top!(file)
      top.map do |changeway|
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
      string += "(#{count_from.to_f / count_to.to_f})".center(25)
      string += "|#{currency_to.ljust(25)}|#{count_to.ljust(25)}|\n"
      string
    end

    def currencys!(file)
      file.write('|')
      file.write('ALL CURRENCYS'.center(129))
      file.write("|\n")
      split_line!(file)
      board.all_currency.each do |currency|
        file.write("#{currency}\n")
      end
    end
  end
end
