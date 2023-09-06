# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountSharesController, type: :controller do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }

  before { sign_in user }

  describe '#index' do
    subject(:index) { get :index, params: { account_id: account.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe '#new' do
    subject(:new) { get :new, params: { account_id: account.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    subject do
      post :create, params: { account_share: {
        name: FFaker::Name.first_name,
        email: FFaker::Internet.email,
        token: SecureRandom.urlsafe_base64(32)
      }, account_id: account.id }
    end

    it { is_expected.to redirect_to(account_shares_path) }
    it { is_expected.to have_http_status(302) }
    it { expect { subject }.to change { AccountShare.where(user_id: user.id).count }.by(1) }
    it { expect { subject }.to change { AccountShare.count }.by(1) }
  end

  describe '#destroy' do
    let!(:account_share) { create(:account_share, user: user, account: account, email: FFaker::Internet.email) }

    subject { delete :destroy, params: { account_id: account.id, id: account_share } }

    context 'when user have access to destroy the share' do
      it { expect { subject }.to change { AccountShare.count }.by(-1) }
      it { is_expected.to redirect_to(account_shares_path) }
    end

    context 'when user not to have access to destroy the share' do
      let(:another_user) { create(:user) }
      before { sign_in another_user }

      it { expect { subject }.not_to(change { AccountShare.count }) }
    end
  end
end
