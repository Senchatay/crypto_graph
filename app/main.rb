# frozen_string_literal: true

require 'require_all'
require 'byebug'
require_all('app/services/**/*.rb')
require_all('app/models/graph/**/*.rb')
require_all('app/models/exchange/**/*.rb')

Presenter::TxtResult.call(RateToGraph.call)
