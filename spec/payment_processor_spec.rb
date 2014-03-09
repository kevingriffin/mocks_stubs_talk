require 'spec_helper'

describe PaymentProcessor do
  describe '.process' do

    subject(:processor) { PaymentProcessor.new }

    let (:user) { User.new }
    let(:connection) { MockConnection.new }

    let(:parameters) do
      {amount: 1400, currency: 'jpy', card: 'token', description: 'Charge Test'}
    end

    before(:each) do
      processor.with_connection(connection).with_result(result)
    end

    context 'in all cases' do
      
      let(:result) {}

      it 'should receieve mocks that match its dependencies' do
        PaymentProcessorConnection.should substitute_for MockConnection
        ChargeResponse.should substitute_for MockResult
      end
    end

    context 'when succeeded' do

      let(:result) { MockResult.new(status: :success) }

      it 'gives the user premium access' do
        processor.process(user, parameters)

        expect(user.premium?).to be_true
        expect(connection.posted_params).to equal parameters
      end

    end

    context 'when failed' do
      let(:result) { MockResult.new(status: :failure) }

      it 'does not give the user premium access' do
        processor.process(user, parameters)

        expect(user.premium?).to be_false
        expect(connection.posted_params).to equal parameters
      end

    end

    context 'when errored' do
      let(:result) { MockResult.new(status: :error) }

      it 'does not give the user premium access' do
        processor.process(user, parameters)

        expect(user.premium?).to be_false
        expect(connection.posted_params).to equal parameters
      end

    end

    context 'when unknown status' do
      let(:result) { MockResult.new(status: :bad_state) }

      it 'throws an exception' do
        expect { processor.process(user, parameters) }.to raise_error(StandardError)
        expect(user.premium?).to be_false
      end

    end

  end
end

class MockConnection
  Surrogate.endow self
  attr_reader :posted_params

  define(:post_data) { |params| @posted_params = params }
end

class MockResult
  Surrogate.endow self
  define(:initialize) { |status:| @status = status }

  define(:parse!) { |result_json| }

  define(:success?) { @status.to_s == 'success' }
  define(:failure?) { @status.to_s == 'failure' }
  define(:error?)   { @status.to_s == 'error' }
end
