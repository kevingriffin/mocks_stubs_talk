require 'uri'
require 'net/http'
require 'json'

class PaymentProcessor
  API_ENDPOINT = 'https://api.stripe.com/v1/charges'
  API_KEY      = 'sk_test_laAkglBmXuzzxpU5T3h8OUiZ'

  def process(user, payment_information)
    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.path)

    req.add_field("Stripe-Version", "2014-01-31")
    req.basic_auth(API_KEY, '')
    req.set_form_data(payment_information)

    result_json = http.request(req).body

    result_hash = JSON.parse(result_json)

    if result_hash['object'] == 'charge'
      user.paid!
    else
      user.canceled!
    end

    result_hash
  end
end
