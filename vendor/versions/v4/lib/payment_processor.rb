require 'uri'
require 'net/http'
require 'json'

class PaymentProcessor
  def process(user, payment_information)
    payment_connection = PaymentProcessorConnection.new

    result_json = payment_connection.post_data(payment_information)
    result_hash = JSON.parse(result_json)

    if result_hash['object'] == 'charge'
      user.paid!
    else
      user.canceled!
    end

    result_hash
  end
end
