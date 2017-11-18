require 'spec_helper'
# require 'dry-validation'

RSpec.describe Cycad::Validators::TransactionValidator do
  context '.validate_new' do
    subject { Cycad::Validators::TransactionValidator.validate_new(input) }

    context 'when the transaction is valid' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: "f032923fhd1d"
        }
      end

      it { is_expected.to eq(true) }
    end

    context 'when the date is not a Date' do
      let(:input) do
        {
          date: "2017/12/12",
          amount: 5,
          category_id: "f032923fhd1d"
        }
      end

      it { is_expected.to eq(false) }
    end

    context 'when the amount is not an integer' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 51.99,
          category_id: "f032923fhd1d"
        }
      end

      it { is_expected.to eq(false) }
    end

    context 'when the amount is zero' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 0,
          category_id: "f032923fhd1d"
        }
      end

      it { is_expected.to eq(false) }
    end

    context 'when the category_id is not a string' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: 3
        }
      end

      it { is_expected.to eq(false) }
    end

    context 'when the note is not a string' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: "f032923fhd1d",
          note: 583,
        }
      end

      it { is_expected.to eq(false) }
    end

    context 'when the note is more than 255 chars' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: "aj38vn4jfu",
          note: (1..256).map { 'a' }.join,
        }
      end

      it { is_expected.to eq(false) }
    end

    context 'when the tags are not an array' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: "aj38vn4jfu",
          tags: "lalala"
        }
      end

      it { is_expected.to eq(false) }
    end

    context 'when the tags are []' do
      let(:input) do
        {
          date: Date.new(2017, 5, 4),
          amount: 5,
          category_id: "aj38vn4jfu",
          tags: []
        }
      end

      it { is_expected.to eq(true) }
    end

    # TODO: when the category_id doesn't find a match in the list of categories
  end
end
