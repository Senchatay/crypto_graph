# frozen_string_literal: true

module Parser
  # Pick commission from parsers
  module Commission
    def self.const_get(name)
      return Parser::Commission::ETH if name[/ERC/]
      return Parser::Commission::Tron if name[/TRC/] || name[/TRX/]

      const = name.to_s.split(' ').join.to_sym
      return Parser::Commission unless Parser::Commission.constants.include?(const)

      super(const)
    end

    def self.const_missing(_name)
      Parser::Commission
    end

    def self.call
      0
    end
  end
end
