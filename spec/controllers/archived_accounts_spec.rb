# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArchivedAccountsController, type: :controller do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }
  let!(:archived_account) { create(:account, :children, parent: account, archived_at: Time.current) }

  before { sign_in user }

  describe '#index' do
    subject(:index) { get :index }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:index) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#archived_accounts' do
    context 'when user have archived account' do
      it { expect(controller.send(:archived_accounts)).to include(archived_account) }
    end
  end

  describe '#restore' do
    subject(:restore) { get :restore, params: { id: archived_account.id } }

    context 'when the current user owns the account' do
      it { expect { subject }.to change { archived_account.reload.archived_at }.to(nil) }
      it { is_expected.to redirect_to(archived_accounts_path) }
    end

    context 'when the current user does not own the account' do
      let(:other_account) { create(:account, :parent) }
      let(:other_user) { create(:user, account: other_account) }

      before { sign_in other_user }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
