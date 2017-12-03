require 'spec_helper'

RSpec.describe Cycad::Validators::TagValidator do
  context '.validate' do
    subject { Cycad::Validators::TagValidator.validate(input) }

    context 'when the name is valid' do
      let(:input) { {name: 'I’m a valid name'} }

      it 'returns an error' do
        expect(subject.errors).to be_empty
      end
    end

    context 'when the name is more than 32 chars' do
      let(:input) { {name: '012345678901234567890123456789012'} }

      it 'returns an error' do
        expect(subject.errors).to eq({name: ['size cannot be greater than 32']})
      end
    end

    context 'when the name is not provided' do
      let(:input) { {name: ''} }

      it 'returns an error' do
        expect(subject.errors).to eq({name: ['must be filled']})
      end
    end
  end
end
