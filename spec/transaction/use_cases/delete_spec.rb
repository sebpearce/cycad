require 'spec_helper'

RSpec.describe Cycad::Transaction::UseCases::Delete do
  context 'delete' do
    let(:transaction) { double(:transaction, id: 42) }
    let(:repo) { double(:repo) }

    before do
      allow(subject).to receive(:repo).and_return(repo)
    end

    it 'deletes a transaction' do
      expect(repo).to receive(:delete).with(transaction.id)
      result = subject.delete(id: transaction.id)
    end
  end
end
