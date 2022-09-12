require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe '#destroy' do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent: parent ) }
    let!(:transaction) { create(:transaction, to_account: child, from_account: parent) }

    subject { delete :destroy, params: { id: transaction } }

    it { expect { subject }.to change { Transaction.count }.from(1).to(0) }
  end
end