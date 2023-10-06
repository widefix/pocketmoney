# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomaticTopupAction, type: :action do
  let(:account) { create(:account, :parent) }
  let(:amount) { 10 }

  subject(:action) { described_class.new(from: account, to: account, amount: amount) }

  describe '#perform_implementation' do
    context 'when a similar transaction already exists' do
      let!(:existing_transaction) do
        create(:transaction, from_account: account,
                             to_account: account,
                             amount: amount,
                             description: 'Automatic Top-up')
      end

      it do
        expect { action.perform }.not_to(change { Transaction.count })
      end
    end

    context 'when all attributes are valid' do
      it { expect { action.perform }.to change { Transaction.count }.by(1) }
    end

    context 'when amount is invalid' do
      let(:amount) { 0 }

      it { expect { action.perform }.not_to(change { Transaction.count }) }
    end
  end

  describe '#existing_transaction' do
    context 'when no existing transaction' do
      it { expect(action.send(:existing_transaction)).to be_nil }
    end

    context 'when one exists' do
      let!(:transaction) do
        create(:transaction, from_account: account,
                             to_account: account,
                             amount: amount,
                             description: 'Automatic Top-up')
      end

      it { expect(action.send(:existing_transaction)).to match(transaction) }
    end
  end
end
