# frozen_string_literal: true

# module Parser
#   module Monitoring
#     # Pick www.bybit.com exchanges
#     module Bybit
#       URL = 'https://api.bybit.com'
#       RECV_WINDOW = '5000'

#       module_function

#       def load
#         get('/v5/asset/exchange/order-record', limit: 10)
#       end

#       def get(path, query = {})
#         time_stamp = DateTime.now.strftime('%Q')
#         Faraday.new(
#           url: URL + path,
#           params: query,
#           headers: {
#             'X-BAPI-API-KEY' => ENV['BYBIT_API_KEY'],
#             'X-BAPI-TIMESTAMP' => time_stamp,
#             'X-BAPI-SIGN' => gen_signature(query.to_query, time_stamp)
#           }
#         ).get
#       end

#       def gen_signature(payload, time_stamp)
#         param_str = time_stamp + ENV['BYBIT_API_KEY'] + RECV_WINDOW + payload
#         OpenSSL::HMAC.hexdigest('sha256', ENV['BYBIT_API_SECRET'], param_str)
#       end
#     end
#   end
# end
