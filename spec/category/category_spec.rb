require 'spec_helper'

RSpec.describe Cycad::Category::CategoryEntity do
  context '.rename' do
    subject { Cycad::Category::CategoryEntity.new('bills') }

    it 'sets its new name' do
      subject.rename('phone')
      expect(subject.name).to eq('phone')
    end
  end
end
