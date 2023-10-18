# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeekToGoalAction, type: :action do
  let!(:parent) { create(:account, :parent) }
  let!(:user) { create(:user, account: parent) }
  let!(:account) { create(:account, :children, parent: parent) }
  let!(:config) { create(:account_automatic_topup_config, params) }
  let!(:objective) { create(:objective, account: account, amount: amount) }
  let(:params) { { from_account: parent, to_account: account, amount: 10 } }
  let(:amount) { 10 }

  subject(:action) { described_class.new.calculate(objective) }

  describe '#calculate' do
    context 'when 1 week left' do
      it { is_expected.to eq(1) }
    end
    context 'when 0 week left' do
      before { create(:transaction, to_account: account, from_account: parent, amount: amount) }
      it { is_expected.to eq(0) }
    end
    context 'when 2 week left' do
      let(:amount) { 20 }
      it { is_expected.to eq(2) }
    end
    context 'when automatic topup configs is empty' do
      before { config.destroy }

      it { is_expected.to eq(999) }
    end
  end
end
