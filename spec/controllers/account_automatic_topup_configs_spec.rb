require "rails_helper"

RSpec.describe AccountAutomaticTopupConfigsController, type: :controller do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }
  let(:params) { { account_id: account.id, id: automatic_topup_config.id, account_automatic_topup_config: { amount: 50 } } }
  let!(:automatic_topup_config) { create(:account_automatic_topup_config, from_account: account, to_account: account) }

  before do
    sign_in user
  end
  
  describe '#new' do
    subject(:new) { get :new, params: { account_id: account.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#edit' do
    subject(:edit) { get :edit, params: { account_id: account.id, id: automatic_topup_config.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:edit) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe "#create" do
    let(:params) { { account_id: account.id, account_automatic_topup_config: { amount: 50 } } }

    it { expect { post :create, params: params }.to change { AccountAutomaticTopupConfig.count }.by(1) }
  end

  describe '#update' do
    subject(:update) { patch :update, params: params }

    it { is_expected.to redirect_to(account_path(account, anchor: 'automatic-top-up')) }
    it { expect { update }.to change { automatic_topup_config.reload.amount }.to(50) }
  end

  describe '#destroy' do
    subject(:destroy) { delete :destroy, params: params }
  
    it { is_expected.to redirect_to(account_path(account, anchor: 'automatic-top-up')) }
    it { expect { destroy }.to change { AccountAutomaticTopupConfig.count }.by(-1) }
  end
end