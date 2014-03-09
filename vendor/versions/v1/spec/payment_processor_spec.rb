require 'spec_helper'

describe PaymentProcessor do
  describe '.process' do

    subject(:processor) { PaymentProcessor.new }
    let (:user) { User.new }

    context 'when succeeded' do

      before(:each) do
        @token = fetch_test_payment_token
      end

      let(:parameters) do
        {amount: 1400, currency: 'jpy', card: @token, description: 'Successful charge'}
      end

      it 'gives the user premium access' do
        processor.process(user, parameters)
        expect(user.premium?).to be_true
      end

    end

    context 'when failed' do
      let(:parameters) do
        {amount: 1400, currency: 'jpy', card: 'FAILURE_TOKEN', description: 'Failure charge'}
      end

      it 'does not give the user premium access' do
        processor.process(user, parameters)
        expect(user.premium?).to be_false
      end

    end
  end
end

def fetch_test_payment_token
  payment_information = {'card[number]' => '4242424242424242', 'card[exp_month]' =>  '12', 'card[exp_year]' => '2015',  'card[cvc]' => '123'}

  uri = URI('https://api.stripe.com/v1/tokens')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  req = Net::HTTP::Post.new(uri.path)

  req.add_field("Stripe-Version", "2014-01-31")
  req.basic_auth('sk_test_laAkglBmXuzzxpU5T3h8OUiZ', '')
  req.set_form_data(payment_information)

  result_json = http.request(req).body

  puts result_json

  JSON.parse(result_json)['id']
end
