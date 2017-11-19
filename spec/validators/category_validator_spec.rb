require 'spec_helper'

RSpec.describe Cycad::Validators::CategoryValidator do
  context '.validate_new' do
    subject { Cycad::Validators::CategoryValidator.validate_new(input) }

    context 'when the name is valid' do
      let(:input) { {name: 'I’m a valid name'} }

      it { is_expected.to eq(true) }
    end

    context 'when the name is more than 32 chars' do
      let(:input) { {name: '012345678901234567890123456789012'} }

      it { is_expected.to eq(false) }
    end

    context 'when the name is not provided' do
      let(:input) { {name: ''} }

      it { is_expected.to eq(false) }
    end
  end
end
