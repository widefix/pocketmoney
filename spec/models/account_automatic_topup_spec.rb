# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountAutomaticTopupConfig, type: :model do
  let!(:account) { create(:account, :parent) }

  subject(:config) do
    build(:account_automatic_topup_config, from_account: account, to_account: account, amount: amount)
  end

  context 'when a positive amount' do
    let(:amount) { 100 }
    it { is_expected.to be_valid }
  end

  context 'when a negative amount' do
    let(:amount) { -100 }
    it { is_expected.not_to be_valid }
  end
end
