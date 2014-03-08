class PaymentProcessorConnection

  API_ENDPOINT = 'https://api.stripe.com/v1/charges'
  API_KEY      = 'sk_test_laAkglBmXuzzxpU5T3h8OUiZ'

  def post_data(parameters)
    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.path)

    req.add_field("Stripe-Version", "2014-01-31")
    req.basic_auth(API_KEY, '')
    req.set_form_data(parameters)

    http.request(req).body
  end
end
