# frozen_string_literal: true

require 'require_all'
require 'byebug'
require_all('app/services/finder/*.rb')
require_all('app/services/presenter/*.rb')
require_all('app/models/graph/**/*.rb')
require_all('app/models/exchange/**/*.rb')
require_all('app/services/loader/*.rb')
require_all('app/services/*.rb')

Presenter::TxtResult.call(RateToGraph.call)
