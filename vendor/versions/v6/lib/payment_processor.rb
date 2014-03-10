require 'uri'
require 'net/http'
require 'json'

class PaymentProcessor
  def process(user, payment_information, connection = nil, result = nil)
    payment_connection = connection || PaymentProcessorConnection.new
    result             = result     || ChargeResult.new

    result_json = payment_connection.post_data(payment_information)

    result.parse_response!(result_json)

    if result.success?
      user.paid!
    elsif result.failure?
      user.canceled!
    elsif result.error?
      user.canceled!
    else
      raise StandardError.new('Unknown state')
    end

    result
  end
end
