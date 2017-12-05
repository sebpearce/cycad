require 'spec_helper'

RSpec.describe Cycad::Category do
  context '.rename' do
    subject { Cycad::Category.new('bills') }

    it 'sets its new name' do
      subject.rename('phone')
      expect(subject.name).to eq('phone')
    end
  end
end
