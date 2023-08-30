# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountSharesController, type: :controller do
  describe '#index' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    subject(:index) { get :index, params: { account_id: account.id } }

    before { sign_in user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe '#new' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    subject(:new) { get :new, params: { account_id: account.id } }

    before { sign_in user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    subject do
      post :create, params: { account_share: {
        name: FFaker::Name.first_name,
        email: FFaker::Internet.email,
        token: SecureRandom.urlsafe_base64(32)
      }, account_id: account.id }
    end

    before { sign_in user }

    it { is_expected.to redirect_to(account_shares_path) }
    it { is_expected.to have_http_status(302) }
    it { expect { subject }.to change { AccountShare.where(user_id: user.id).count }.by(1) }
    it { expect { subject }.to change { AccountShare.count }.by(1) }
  end

  describe '#destroy' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:second_user) { create(:user) }
    let!(:account_share) { create(:account_share, user: user, account: account, email: second_user.email) }

    subject { delete :destroy, params: { account_id: account.id, id: account_share } }
    before { sign_in user }
    it { expect { subject }.to change { AccountShare.count }.from(1).to(0) }
  end
end
