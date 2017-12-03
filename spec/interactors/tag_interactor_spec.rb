require 'spec_helper'
require 'date'
require 'pry'

RSpec.describe Cycad::Interactors::Tag do
  subject { Cycad::Interactors::Tag }

  context 'with no existing tag' do
    context 'self.create' do
      it 'creates a tag' do
        result = subject.create('turkey')
        expect(result.tag).to_not be_nil
        expect(result.tag.name).to eq('turkey')
        expect(result.tag.id).to_not be_nil
        expect(Cycad.repo.tags.first.name).to eq('turkey')
      end
    end
  end

  context 'with an existing tag and transaction' do
    let!(:existing_tag) { subject.create('otter').tag }
    let!(:existing_transaction) do
      Cycad.create_transaction(
        date: Date.new(2017,11,10),
        amount: 50,
        category_id: 'blah'
      ).transaction
    end

    context 'self.rename' do
      it 'renames the tag' do
        result = subject.rename(existing_tag.id, 'walrus')
        expect(result.tag.name).to eq 'walrus'
        expect(Cycad.repo.tags.first.name).to eq('walrus')
      end
    end

    context 'self.attach' do
      it 'attaches an existing tag to a transaction' do
        subject.attach(existing_transaction.id, existing_tag.id)
        expect(existing_transaction.tags).to contain_exactly(existing_tag)
        expect(Cycad.repo.transactions.first.tags).to contain_exactly(existing_tag)
      end
    end

    context 'self.unattach' do
      before do
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
        expect(Cycad.repo.tags).to include(existing_tag)
        subject.purge(existing_tag.id)
        expect(Cycad.repo.tags).to_not include(existing_tag)
      end
    end
  end
end
