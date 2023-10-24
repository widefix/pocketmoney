require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe '#destroy' do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent: parent ) }
    let(:store) { create(:account, :store) }

    subject { delete :destroy, params: { id: transaction } }

    context 'when cancel the topup transaction' do
      let!(:transaction) { create(:transaction, to_account: child, from_account: parent) }

      it { expect { subject }.to change { Transaction.count }.from(1).to(0) }
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(account_path(transaction.to_account)) }
    end

    context 'when cancel the spend transaction' do
      let!(:transaction) { create(:transaction, to_account: store, from_account: child) }

      it { expect { subject }.to change { Transaction.count }.from(1).to(0) }
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(account_path(transaction.from_account)) }
    end
  end
end
