require 'spec_helper'
require 'date'

RSpec.describe Cycad::Tagger do
  let!(:existing_tag) { Cycad::Tagger.create_tag('otter') }
  let!(:existing_transaction) do
    Cycad::Transaction.new(
      date: Date.new(2017,11,10),
      amount: 50,
      category_id: 5
    )
  end

  context 'self.create_tag' do
    it 'creates a tag' do
      new_tag = Cycad::Tagger.create_tag('turkey')
      expect(new_tag.name).to eq('turkey')
      expect(new_tag.id).to_not be_nil
    end
  end

  context 'self.remove_tag' do
    before do
      Cycad::Tagger.attach_tag(existing_transaction, existing_tag)
    end

    it 'removes an existing tag from a transaction' do
      Cycad::Tagger.remove_tag(existing_transaction, existing_tag)
      expect(existing_transaction.tags).to_not include(existing_tag.id)
    end
  end

  context 'self.attach_tag' do
    it 'attaches an existing tag to a transaction' do
      Cycad::Tagger.attach_tag(existing_transaction, existing_tag)
      expect(existing_transaction.tags).to contain_exactly(existing_tag.id)
    end
  end

  context 'self.update_tag_name' do
    let(:new_name) { 'boris' }

    it 'edits an existing tag' do
      Cycad::Tagger.update_tag_name(existing_tag, new_name)
      expect(existing_tag.name).to eq(new_name)
    end
  end
end
