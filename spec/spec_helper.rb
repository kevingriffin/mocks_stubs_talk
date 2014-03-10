require_relative '../lib/payment_processor'
require_relative '../lib/payment_processor_connection'
require_relative '../lib/charge_result'
require_relative '../lib/user'

require 'uri'
require 'net/http'
require 'webmock/rspec'
require 'surrogate/rspec'

WebMock.allow_net_connect!
