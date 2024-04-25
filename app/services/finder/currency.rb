# frozen_string_literal: true

module Finder
  # Search cheapest way for selling currency pair. Using algorith dfs https://neerc.ifmo.ru/wiki/index.php?title=%D0%98%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_%D0%BE%D0%B1%D1%85%D0%BE%D0%B4%D0%B0_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83_%D0%B4%D0%BB%D1%8F_%D0%BF%D0%BE%D0%B8%D1%81%D0%BA%D0%B0_%D1%86%D0%B8%D0%BA%D0%BB%D0%B0
  class Currency
    attr_reader :nodes_by_name

    EXCEPTED_CURRENCY = %i[NGN OMG ROOBEE].freeze

    def initialize(nodes)
      @nodes_by_name = Hash.new { |hash, key| hash[key] = [] }
      nodes.each do |node|
        @nodes_by_name[node.name] << node unless EXCEPTED_CURRENCY.include?(node.name)
      end
      nodes_by_name
    end

    def with_other_exchange(current_node)
      nodes_by_name[current_node.name]
    end

    def names(excepted_name = nil)
      return nodes_by_name.keys unless excepted_name

      nodes_by_name.keys - [excepted_name]
    end

    def nodes(name)
      nodes_by_name[name]
    end
  end
end
