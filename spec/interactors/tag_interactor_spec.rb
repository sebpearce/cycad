require 'spec_helper'
require 'date'
require 'pry'

RSpec.describe Cycad::Interactors::Tag do
  let!(:existing_tag) { Cycad::Interactors::Tag.create('otter') }
  let!(:existing_transaction) do
    Cycad.add_transaction(
      date: Date.new(2017,11,10),
      amount: 50,
      category_id: 5
    )
  end

  context 'self.create' do
    it 'creates a tag' do
      new_tag = Cycad::Interactors::Tag.create('turkey')
      expect(new_tag.name).to eq('turkey')
      expect(new_tag.id).to_not be_nil
    end
  end

  context 'self.rename' do
    it 'renames the tag' do
      Cycad::Interactors::Tag.rename(existing_tag.id, 'walrus')
      expect(existing_tag.name).to eq 'walrus'
    end
  end

  context 'self.attach' do
    it 'attaches an existing tag to a transaction' do
      Cycad::Interactors::Tag.attach(existing_transaction.id, existing_tag.id)
      expect(existing_transaction.tags).to contain_exactly(existing_tag)
    end
  end

  context 'self.unattach' do
    before do
      Cycad::Interactors::Tag.attach(existing_transaction.id, existing_tag.id)
    end

    it 'removes an existing tag from a transaction' do
      expect(existing_transaction.tags).to include(existing_tag)
      Cycad::Interactors::Tag.unattach(existing_transaction.id, existing_tag.id)
      expect(existing_transaction.tags).to_not include(existing_tag)
    end
  end

  context 'self.purge' do
    it 'purges a tag from the repo' do
      expect(Cycad.repo.tags).to include(existing_tag)
      Cycad::Interactors::Tag.purge(existing_tag.id)
      expect(Cycad.repo.tags).to_not include(existing_tag)
    end
  end
end
