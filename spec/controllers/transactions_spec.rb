require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe '#destroy' do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent_id: parent.id ) }
    let!(:transaction) { create(:transaction, to_account_id: child.id, from_account_id: parent.id) }

    subject { delete :destroy, params: { id: transaction.id } }

    it { expect { subject }.to change { Transaction.count }.from(1).to(0) }
  end
end