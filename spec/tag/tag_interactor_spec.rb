require 'spec_helper'
require 'date'
require 'pry'

RSpec.describe Cycad::Tag::Interactor do
  subject { Cycad::Tag::Interactor }
  let(:repo) { double(Cycad::TransactionsRepo::MemoryRepo) }

  before do
    allow(subject).to receive(:repo) { repo }
  end

  context 'with no existing tag' do
    context 'self.create' do
      it 'creates a tag' do
        expect(repo).to receive(:persist_tag)
        result = subject.create('turkey')
        expect(result.tag).to_not be_nil
        expect(result.tag.name).to eq('turkey')
        expect(result.tag.id).to_not be_nil
      end
    end
  end

  context 'with an existing tag and transaction' do
    let!(:existing_tag) { Cycad::Tag.new('otter') }
    let!(:existing_transaction) do
      Cycad.create_transaction(
        date: Date.new(2017,11,10),
        amount: 50,
        category_id: 'blah'
      ).transaction
    end

    context 'self.rename' do
      it 'renames the tag' do
        expect(repo).to receive(:find_tag).and_return(existing_tag)
        result = subject.rename(existing_tag.id, 'walrus')
        expect(result.tag.name).to eq 'walrus'
      end
    end

    context 'self.attach' do
      it 'attaches an existing tag to a transaction' do
        expect(repo).to receive(:find_tag).and_return(existing_tag)
        expect(repo).to receive(:find_transaction).and_return(existing_transaction)
        subject.attach(existing_transaction.id, existing_tag.id)
        expect(existing_transaction.tags).to contain_exactly(existing_tag)
        expect(Cycad.repo.transactions.first.tags).to contain_exactly(existing_tag)
      end
    end

    context 'self.unattach' do
      before do
        allow(repo).to receive(:find_tag).and_return(existing_tag)
        allow(repo).to receive(:find_transaction).and_return(existing_transaction)
        subject.attach(existing_transaction.id, existing_tag.id)
      end

      it 'removes an existing tag from a transaction' do
        expect(existing_transaction.tags).to include(existing_tag)
        expect(Cycad.repo.transactions.first.tags).to include(existing_tag)
        subject.unattach(existing_transaction.id, existing_tag.id)
        expect(existing_transaction.tags).to_not include(existing_tag)
        expect(Cycad.repo.transactions.first.tags).to_not include(existing_tag)
      end
    end

    context 'self.purge' do
      it 'purges a tag from the repo' do
        expect(repo).to receive(:find_tag).with(existing_tag.id).and_return(existing_tag)
        expect(repo).to receive(:purge_tag).with(existing_tag)
        subject.purge(existing_tag.id)
      end
    end
  end
end
