require 'uri'
require 'net/http'
require 'json'
require 'deject'

class PaymentProcessor
  Deject self

  dependency(:connection) { PaymentProcessorConnection.new }
  dependency(:result) { ChargeResult.new }

  def process(user, payment_information)
    result_json = connection.post_data(payment_information)

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
