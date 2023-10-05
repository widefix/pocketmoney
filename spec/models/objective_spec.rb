# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Objective, type: :model do
  let!(:account) { create(:account, :parent) }
  let(:amount) { FFaker::Number.number }
  let(:name) { FFaker::Book.title }

  subject(:config) do
    build(:objective, name: name, account: account, amount: amount)
  end

  context 'when params is valid' do
    it { is_expected.to be_valid }
  end

  context 'when params is not valid' do
    context 'when a negative amount' do
      let(:amount) { -100 }
      it { is_expected.not_to be_valid }
    end
    context 'when has not name' do
      let(:name) { '' }
      it { is_expected.not_to be_valid }
    end
    context 'when has not amount' do
      let(:amount) { '' }
      it { is_expected.not_to be_valid }
    end
  end
end
