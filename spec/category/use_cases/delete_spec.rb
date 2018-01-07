require 'spec_helper'

RSpec.describe Cycad::Category::UseCases::Delete do
  context 'delete' do
    let(:repo) { double }

    before do
      allow(subject).to receive(:repo).and_return(repo)
    end

    it 'deletes a category' do
      expect(repo).to receive(:delete).with('an_id').and_return(double)
      subject.delete(id: 'an_id')
    end
  end
end
