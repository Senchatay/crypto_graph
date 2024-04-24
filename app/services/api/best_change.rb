# frozen_string_literal: true

require 'csv'
require 'zip'
require 'tempfile'

module API
  # Get info from bestchange API
  class BestChange
    include Singleton

    INFO_FILE = 'http://api.bestchange.ru/info.zip'
    TOP_EXCHANGER_LIMIT = 3

    def self.method_missing(method_name, *args, &blk)
      if instance.respond_to?(method_name)
        instance.send(method_name, *args, &blk)
      else
        super
      end
    end

    def self.respond_to_missing?
      true
    end

    def rates(from, to)
      from_id = currencies.key(from)
      to_id = currencies.key(to)
      return [] if [from_id, to_id].any?(&:nil?)
      return [] if from_id == to_id

      rates = ways(from_id, to_id).map do |entry|
        parse_info_from_row(from, to, *entry[2..4])
      end
      rates.lazy.sort_by { |e| e[:distance] }.first(TOP_EXCHANGER_LIMIT)
    end

    def currencies
      @currencies ||= csv_data[:cy].each_with_object({}) do |row, hash|
        # hash[row[2]] = row[0].to_i
        hash[row[0].to_i] = row[3]
      end
    end

    private

    def parse_info_from_row(currency_from, currency_to, exchanger_id, amount_from, amount_to)
      distance = amount_from.to_f / amount_to.to_f
      {
        currency_from:,
        currency_to:,
        exchanger: exchangers[exchanger_id.to_i],
        amount_from: amount_from.to_f,
        amount_to: amount_to.to_f,
        distance:
      }
    end

    def ways(from_id, to_id)
      rates_list.select do |edge|
        edge[0].to_i == from_id && edge[1].to_i == to_id
      end
    end

    def rates_list
      @rates_list ||= csv_data[:rates]
    end

    def exchangers
      @exchangers ||= csv_data[:exch].each_with_object({}) do |row, hash|
        hash[row[0].to_i] = row[1]
      end
    end

    def csv_data
      @csv_data ||= parse_csv_contents
    end

    def parse_csv_contents
      csv_data = {}
      %w[rates cy exch bcodes brates].each do |key|
        csv = contents.detect { |entry| entry[:name] == "bm_#{key}.dat" }[:content]
        csv_data[key.to_sym] = CSV.parse csv, col_sep: ';'
      end
      csv_data
    end

    def contents
      return @contents if @contents

      @contents = []
      load_contents!
      @contents
    end

    # Load zip file, unzip and save files content in memory
    def load_contents!
      temp_file = Tempfile.new(['bestchange', '.zip'])
      begin
        temp_file.write(Faraday.get(INFO_FILE).body)
        unzip(temp_file.path)
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    def unzip(temp_file_path)
      ::Zip::File.open(temp_file_path) do |zip_file|
        zip_file.glob('*.dat').each do |entry|
          push_content!(entry)
        end
      end
    end

    def push_content!(entry)
      name = entry.name
      file = Tempfile.new(name)
      begin
        file.write(entry.get_input_stream.read)
        content = File.open(file.path, encoding: 'windows-1251').read
        @contents << { name:, content: }
      ensure
        file.close
        file.unlink
      end
    end

    # def info
    #   csv_info = contents.detect { |x| x[:name] == 'bm_info.dat' }[:content]
    #   array_info = CSV.parse csv_info, col_sep: '='
    #   Hash[array_info]
    # end
  end
end
