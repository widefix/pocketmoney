require "rails_helper"

RSpec.describe AccountAutomaticTopupConfigsController, type: :controller do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }
  
  describe '#new' do
    subject(:new) { get :new, params: { account_id: account.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#edit' do
    let!(:automatic_topup_config) { create(:account_automatic_topup_config, from_account: account, to_account: account) }

    subject(:edit) { get :edit, params: { account_id: account.id, id: automatic_topup_config.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:edit) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#create' do
    subject(:create) { post :create, params: { account_id: account.id } }

    it { expect(response).to have_http_status(:success) }
  end

  describe '#update' do
    let!(:automatic_topup_config) { create(:account_automatic_topup_config, from_account: account, to_account: account) }

    subject(:update) { patch :update, params: { account_id: account.id, id: automatic_topup_config.id, account_automatic_topup_config: { amount: 42 } } }

    before do
      sign_in user
    end
  

    it { is_expected.to redirect_to(account_path(account)) }
    it { expect { update }.to change { automatic_topup_config.reload.amount }.to(42) }
  end

  describe '#destroy' do
    let!(:automatic_topup_config) { create(:account_automatic_topup_config, from_account: account, to_account: account) }

    subject(:destroy) { delete :destroy, params: { account_id: account.id, id: automatic_topup_config.id } }

    before do
      sign_in user
    end
  
    it { is_expected.to redirect_to(account_path(account)) }
    it { expect { destroy }.to change { AccountAutomaticTopupConfig.count }.by(-1) }
  end
end