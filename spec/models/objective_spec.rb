# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Objective, type: :model do
  let!(:account) { create(:account, :parent) }
  let!(:user) { create(:user, account: account) }
  let(:amount) { 10 }
  let(:name) { FFaker::Book.title }

  subject(:config) do
    build(:objective, name: name, account: account, amount: amount)
  end

  context 'when params is valid' do
    it { is_expected.to be_valid }
  end

  context 'when params is not valid' do
    context 'when a negative amount' do
      let(:amount) { -10 }
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

  describe '#weeks_to_achieve' do
    let!(:children) { create(:account, :children, parent: account) }
    let!(:config) { create(:account_automatic_topup_config, params) }
    let!(:objective) { create(:objective, account: children, amount: amount) }
    let(:params) { { from_account: account, to_account: children, amount: 10 } }

    context 'when balance is greater than or equal to amount' do
      before { create(:transaction, to_account: children, from_account: account, amount: amount) }

      it { expect(objective.weeks_to_achieve).to eq(-1) }
    end

    context 'when no top-up configs' do
      before { config.destroy }

      it { expect(objective.weeks_to_achieve).to eq(0) }
    end

    context 'when goal is almost achieved' do
      it { expect(objective.weeks_to_achieve).to eq(1) }
    end

    context 'when there are 2 weeks left to achieve' do
      let(:amount) { 20 }

      it { expect(objective.weeks_to_achieve).to eq(2) }
    end
  end
end
