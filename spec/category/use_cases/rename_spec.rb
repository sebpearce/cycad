require 'spec_helper'

RSpec.describe Cycad::Category::UseCases::Rename do
  context 'validate' do
    context 'when the name is under 32 chars' do
      it 'is valid' do
        result = subject.validate({
          name: 'Good format'
        })

        expect(result).to be_success
      end
    end

    context 'when the name is more than 32 chars' do
      it 'is invalid' do
        result = subject.validate({
          name: 'Good format except for the fact that it is too long'
        })

        expect(result).to be_failure
      end
    end
  end

  context 'rename' do
    let(:repo) { double }

    before do
      allow(subject).to receive(:repo).and_return(repo)
    end

    it 'renames the category' do
      expect(repo).to receive(:rename).with(3, 'a name').and_return(double)
      subject.rename(id: 3, name: 'a name')
    end
  end
end
