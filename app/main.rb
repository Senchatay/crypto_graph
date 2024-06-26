# frozen_string_literal: true

# require 'active_support/concern'
# require 'async/http/faraday'
require 'require_all'
require 'byebug'
require 'faraday'
require 'dotenv/load'
require 'nokogiri'
require 'uri'
require 'websocket-client-simple'
require_all('app/services/algorithm/**/*.rb')
require_all('app/services/api/*.rb')
require_all('app/services/finder/*.rb')
require_all('app/services/presenter/*.rb')
require_all('app/models/graph/**/*.rb')
require_all('app/models/exchange/**/*.rb')
require_all('app/services/monkey_patching/**/*.rb')
require_all('app/services/parser/*.rb')
require_all('app/services/parser/commission/*.rb')
require_all('app/services/parser/monitoring/**/*.rb')
require_all('app/services/parser/stock/**/*.rb')
require_all('app/services/loader/*.rb')
require_all('app/services/*.rb')

loop do
  $start_time = Time.now
  Presenter::TxtResult.call(RateToGraph.call)
  Loader::ChangerLoader.clear!
  Loader::NodeLoader.clear!
  Loader::BlockchainCommissionLoader.clear!
end
