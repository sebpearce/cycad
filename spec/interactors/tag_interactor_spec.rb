require 'spec_helper'
require 'date'

RSpec.describe Cycad::Interactors::Tag do
  let!(:existing_tag) { Cycad::Interactors::Tag.create('otter') }
  let!(:existing_transaction) do
    Cycad::Transaction.new(
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

  context 'self.attach' do
    it 'attaches an existing tag to a transaction' do
      Cycad::Interactors::Tag.attach(existing_transaction, existing_tag)
      expect(existing_transaction.tags).to contain_exactly(existing_tag)
    end
  end

  context 'self.remove' do
    before do
      Cycad::Interactors::Tag.attach(existing_transaction, existing_tag)
    end

    it 'removes an existing tag from a transaction' do
      Cycad::Interactors::Tag.remove(existing_transaction, existing_tag)
      expect(existing_transaction.tags).to_not include(existing_tag)
    end
  end
end
