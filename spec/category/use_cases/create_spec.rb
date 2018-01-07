require 'spec_helper'

RSpec.describe Cycad::Category::UseCases::Create do
  context 'validate' do
    context 'when the name is under 32 chars' do
      it 'is valid' do
        result = subject.validate({
          name: 'Cat toys'
        })

        expect(result).to be_success
      end
    end

    context 'when the name is more than 32 chars' do
      it 'is invalid' do
        result = subject.validate({
          name: 'Cat toys and other things of interest'
        })

        expect(result).to be_failure
        errors = result.value
        expect(errors[:name]).to include('size cannot be greater than 32')
      end
    end
  end

  context 'create' do
    let(:repo) { double }

    before do
      allow(subject).to receive(:repo).and_return(repo)
    end

    it 'creates the category' do
      expect(repo).to receive(:create).with(name: 'a name').and_return(double)
      subject.create(name: 'a name')
    end
  end
end
