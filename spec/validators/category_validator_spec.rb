require 'spec_helper'

RSpec.describe Cycad::Validators::CategoryValidator do
  context '.validate' do
    subject { Cycad::Validators::CategoryValidator.validate(category) }

    context 'when the name is valid' do
      let(:category) { Cycad::Category.new('I’m a valid name') }

      it 'has no errors' do
        expect(subject.errors).to be_empty
      end
    end

    context 'when the name is more than 32 chars' do
      let(:category) { Cycad::Category.new('012345678901234567890123456789012') }

      it 'returns an error' do
        expect(subject.errors).to eq({name: ["size cannot be greater than 32"]})
      end
    end

    context 'when the name is not provided' do
      let(:category) { Cycad::Category.new('') }

      it 'returns an error' do
        expect(subject.errors).to eq({name: ["must be filled"]})
      end
    end
  end
end
