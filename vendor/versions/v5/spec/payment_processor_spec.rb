require 'spec_helper'

describe PaymentProcessor do
  describe '.process' do

    subject(:processor) { PaymentProcessor.new }
    let (:user) { User.new }

    context 'when succeeded' do

      let(:parameters) do
        {amount: 1400, currency: 'jpy', card: 'token', description: 'Successful charge'}
      end

      let(:connection) { SuccessConnection.new }

      it 'gives the user premium access' do
        processor.process(user, parameters, connection)
        expect(user.premium?).to be_true
      end

    end

    context 'when failed' do
      let(:parameters) do
        {amount: 1400, currency: 'jpy', card: 'token', description: 'Failure charge'}
      end

      let(:connection) { FailureConnection.new }

      it 'does not give the user premium access' do
        processor.process(user, parameters, connection)
        expect(user.premium?).to be_false
      end

    end
  end
end

class SuccessConnection
  def post_data(params)
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
end

class FailureConnection

  def post_data(params)
    '
  {
    "error": {
      "type": "invalid_request_error",
      "message": "You cannot use a Stripe token more than once: tok_103cy82aR6f6MydqB7tuTNB5"
    }
  }
    '
  end
end
