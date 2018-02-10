require 'spec_helper'

RSpec.describe Cycad::Transaction::Validator do
  context 'self.validate' do
    subject { Cycad::Transaction::Validator.validate_for_create(input) }

    context 'when the transaction is valid' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: -5,
          category_id: 4,
        }
      end

      it 'returns no errors' do
        expect(subject.errors).to be_empty
      end
    end

    context 'when the date is not a Date' do
      let(:input) do
        {
          date: '2017/12/12',
          amount: 5,
          category_id: 23,
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({date: ['must be a date']})
      end
    end

    context 'when the amount is not an integer' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 51.99,
          category_id: 5,
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({amount: ['must be an integer']})
      end
    end

    context 'when the amount is zero' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 0,
          category_id: 3,
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({amount: ['must not be one of: 0']})
      end
    end

    context 'when the category_id is not an int' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: 'foo'
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({category_id: ['must be an integer']})
      end
    end

    context 'when the note is not a string' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: 2,
          note: 583,
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({note: ['must be a string']})
      end
    end

    context 'when the note is more than 255 chars' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: 10,
          note: (1..256).map { 'a' }.join,
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({note: ['size cannot be greater than 255']})
      end
    end

    context 'when the tags are not a string' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: 13,
          tags: ['asdf', 'asdf']
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({tags: ['must be a string']})
      end
    end

    context 'when the tags are an empty string' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: 6,
          tags: ''
        }
      end

      it 'returns no errors' do
        expect(subject.errors).to be_empty
      end
    end

    # TODO: when the category_id doesn't find a match in the list of categories
  end

  context 'self.partial_validate' do
    subject { Cycad::Transaction::Validator.validate_for_update(input) }

    context 'when only a correct date is passed in' do
      let(:input) do
        {
          date: Date.new(2001, 5, 1)
        }
      end

      it 'returns no errors' do
        expect(subject.errors).to be_empty
      end
    end

    context 'when only an incorrect date is passed in' do
      let(:input) do
        {
          date: 'lulz'
        }
      end

      it 'returns an error' do
        expect(subject.errors).to eq({date: ['must be a date']})
      end
    end
  end
end
