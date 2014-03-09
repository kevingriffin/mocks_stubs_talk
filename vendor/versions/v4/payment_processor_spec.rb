require 'spec_helper'

describe PaymentProcessor do
  describe '.process' do

    subject(:processor) { PaymentProcessor.new }
    let (:user) { User.new }

    context 'when succeeded' do

      let(:parameters) do
        {amount: 1400, currency: 'jpy', card: @token, description: 'Successful charge'}
      end

      before(:each) do
        stub_connection_class(success: true)
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

      before(:each) do
        stub_connection_class(success: false)
      end

      it 'does not give the user premium access' do
        processor.process(user, parameters)
        expect(user.premium?).to be_false
      end

    end
  end
end

def stub_connection_class(success:)
  response = success ? success_response : failure_response
  PaymentProcessorConnection.any_instance.stub(:post_data).and_return(response)
end

def success_response
  '
{
  "id": "ch_103cxv2aR6f6MydqHbfpBUKs",
  "object": "charge",
  "created": 1394275693,
  "livemode": false,
  "paid": true,
  "amount": 1400,
  "currency": "jpy",
  "refunded": false,
  "card": {
    "id": "card_103cxu2aR6f6MydqZ0A30M0T",
    "object": "card",
    "last4": "4242",
    "type": "Visa",
    "exp_month": 8,
    "exp_year": 2015,
    "fingerprint": "iMOxhFMRYQ1AHlyg",
    "customer": null,
    "country": "US",
    "name": null,
    "address_line1": null,
    "address_line1_check": null,
    "address_zip_check": null
  },
  "captured": true,
  "refunds": [

  ],
  "balance_transaction": "txn_103cxv2aR6f6MydqewnTtauv",
  "failure_message": null,
  "failure_code": null,
  "amount_refunded": 0,
  "customer": null,
  "invoice": null,
  "description": "Charge for test@example.com",
  "dispute": null,
  "metadata": {
  }
}'

end

def failure_response
  '
{
  "error": {
    "type": "invalid_request_error",
    "message": "You cannot use a Stripe token more than once: tok_103cy82aR6f6MydqB7tuTNB5"
  }
}
  '
end
