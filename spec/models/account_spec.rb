# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#accumulative_balance_data' do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent: parent) }
    let!(:first_transaction) { create(:transaction, to_account: child, from_account: parent, amount: 100, created_at: 1.day.ago) }
    let!(:second_transaction) { create(:transaction, to_account: child, from_account: parent, amount: 50, created_at: Time.current) }

    it 'calculates accumulative balance data' do
      expect(parent.accumulative_balance_data).to eq({ first_transaction.created_at.to_date => 100, second_transaction.created_at.to_date => 150 })
    end
  end
end
