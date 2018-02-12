require 'spec_helper'

RSpec.describe Cycad::Category::Validator do
  context '.validate' do
    let(:repo) { double }
    subject { Cycad::Category::Validator.validate(repo, input) }

    context 'when the name is unique' do
      before do
        allow(repo).to receive(:unique?) { true }
      end

      context 'when the name is valid' do
        let(:input) { {name: 'I’m a valid name'} }

        it 'has no errors' do
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

    context 'when the name is not unique' do
      before do
        allow(repo).to receive(:unique?) { false }
      end

      let(:input) { {name: 'parsley'} }

      it 'returns an error' do
        expect(subject.errors).to eq({name: ['name already exists in the database']})
      end
    end
  end
end
