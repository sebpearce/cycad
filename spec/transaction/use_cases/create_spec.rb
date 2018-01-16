require 'spec_helper'

RSpec.describe Cycad::Transaction::UseCases::Create do
  context 'validate' do
    it 'is valid when date, amount and category_id are specified' do
      result = subject.validate({
        date: Date.parse('2017-12-20'),
        amount: 20,
        category_id: 1
      })

      expect(result).to be_success
    end

    it 'is invalid when a date is not specified' do
      result = subject.validate({
        amount: 20,
        category_id: 1
      })

      expect(result).to be_failure
      errors = result.value
      expect(errors[:date]).to include('is missing')
    end
  end

  context 'create' do
    let(:repo) { double }

    before do
      allow(subject).to receive(:repo).and_return(repo)
    end

    it 'creates the transaction' do
      input = {
        date: Date.parse('2017-12-20'),
        amount: 20,
        category_id: 1
      }

      expect(repo).to receive(:create).with(input).and_return(double)
      subject.create(input)
    end
  end
end
