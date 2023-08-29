# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#accumulative_balance_data' do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent: parent) }
    let!(:first_transaction) { create(:transaction, to_account: parent, from_account: child, amount: 100.0, created_at: 2.day.ago) }
    let!(:second_transaction) { create(:transaction, to_account: child, from_account: parent, amount: 70.0, created_at: 1.day.ago) }
    let!(:third_transaction) { create(:transaction, to_account: parent, from_account: child, amount: 50.0, created_at: Time.current) }

    context 'with positive and negative transactions' do
      it do
        expect(parent.accumulative_balance_data).to eq({
                                                         first_transaction.created_at.to_date.strftime('%Y-%m-%d') => 100.0,
                                                         second_transaction.created_at.to_date.strftime('%Y-%m-%d') => 30.0,
                                                         third_transaction.created_at.to_date.strftime('%Y-%m-%d') => 80.0
                                                       })
      end
    end
  end
end
