require 'spec_helper'

describe PaymentProcessor do
  describe '.process' do

    subject(:processor) { PaymentProcessor.new }

    let (:user) { User.new }
    let(:connection) { MockConnection.new }

    let(:parameters) do
      {amount: 1400, currency: 'jpy', card: 'token', description: 'Charge Test'}
    end

    context 'when succeeded' do

      let(:result) { MockResult.new(status: :success) }

      it 'gives the user premium access' do
        processor.process(user, parameters, connection, result)
        expect(user.premium?).to be_true
        expect(connection.posted_params).to equal parameters
      end

    end

    context 'when failed' do
      let(:result) { MockResult.new(status: :failure) }

      it 'does not give the user premium access' do
        processor.process(user, parameters, connection, result)
        expect(user.premium?).to be_false
        expect(connection.posted_params).to equal parameters
      end

    end

    context 'when errored' do
      let(:result) { MockResult.new(status: :error) }

      it 'does not give the user premium access' do
        processor.process(user, parameters, connection, result)
        expect(user.premium?).to be_false
        expect(connection.posted_params).to equal parameters
      end

    end

    context 'when unknown status' do
      let(:result) { MockResult.new(status: :bad_state) }

      it 'throws an exception' do
        expect { processor.process(user, parameters, connection, result) }.to raise_error(StandardError)
        expect(user.premium?).to be_false
      end
    end
  end
end

class MockConnection
  attr_reader :posted_params
  def post_data(params)
    @posted_params = params
  end
end

class MockResult
  def initialize(status:)
    @status = status
  end

  def parse_response!(result_json)
  end

  def success?
    @status.to_s == 'success'
  end

  def failure?
    @status.to_s == 'failure'
  end

  def error?
    @status.to_s == 'error'
  end
end
