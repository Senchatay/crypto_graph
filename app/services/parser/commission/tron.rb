# frozen_string_literal: true

module Parser
  module Commission
    # Pick ETH commission from web
    module Tron
      # Comission is zero if transaction per day is under 5000 freepoints
      def self.call
        0
      end
    end
  end
end
