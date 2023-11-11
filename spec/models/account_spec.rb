# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#accumulative_balance_data' do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent: parent) }
    let!(:first_transaction) do
      create(:transaction, to_account: child, from_account: parent, amount: 100.0, created_at: 1.month.ago)
    end
    let!(:second_transaction) do
      create(:transaction, to_account: parent, from_account: child, amount: 70.0, created_at: 1.week.ago)
    end
    let!(:third_transaction) do
      create(:transaction, to_account: child, from_account: parent, amount: 50.0, created_at: Time.current)
    end

    context 'with positive and negative transactions grouped dy day' do
      it do
        expect(child.accumulative_balance_data)
          .to eq({
                   first_transaction.created_at.to_date.strftime('%Y-%m-%d') => 100.0,
                   second_transaction.created_at.to_date.strftime('%Y-%m-%d') => 30.0,
                   third_transaction.created_at.to_date.strftime('%Y-%m-%d') => 80.0
                 })
      end
    end

    context 'with positive and negative transactions grouped dy week' do
      before { child.update_attribute(:accumulative_balance_timeframe, 'week') }

      it do
        expect(child.accumulative_balance_data)
          .to eq({
                   first_transaction.created_at.beginning_of_week.to_date.strftime('%Y-%m-%d') => 100.0,
                   second_transaction.created_at.beginning_of_week.to_date.strftime('%Y-%m-%d') => 30.0,
                   third_transaction.created_at.beginning_of_week.to_date.strftime('%Y-%m-%d') => 80.0
                 })
      end
    end

    context 'with positive and negative transactions grouped dy month' do
      before { child.update_attribute(:accumulative_balance_timeframe, 'month') }

      it do
        expect(child.accumulative_balance_data)
          .to eq({
                   first_transaction.created_at.beginning_of_month.to_date.strftime('%Y-%m-%d') => 100.0,
                   third_transaction.created_at.beginning_of_month.to_date.strftime('%Y-%m-%d') => 80.0
                 })
      end
    end
  end
end
