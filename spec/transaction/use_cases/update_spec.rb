require 'spec_helper'

RSpec.describe Cycad::Transaction::UseCases::Update do
  context '.validate' do
    context 'when a correctly formatted date is specified' do
      let(:date_input) { Date.parse('2017-12-27') }

      it 'is valid' do
        result = subject.validate({
          id: 'im_an_id',
          attrs: {
            date: date_input
          }
        })

        expect(result).to be_success
      end
    end

    context 'when an incorrect date is specified' do
      let(:date_input) { '2017-12-27' }

      it 'is invalid' do
        result = subject.validate({
          id: 'im_an_id',
          attrs: {
            date: date_input
          }
        })

        expect(result).to be_failure
        errors = result.value
        expect(errors[:date]).to include('must be a date')
      end
    end
  end

  context '.update' do
    let(:repo) { double }

    before do
      allow(subject).to receive(:repo).and_return(repo)
    end

    it 'updates the transaction' do
      input = {
        id: 'im_an_id',
        attrs: {
          amount: 5000
        }
      }

      expect(repo).to receive(:update).with(input[:id], input[:attrs]).and_return(double)
      subject.update(input)
    end
  end
end
