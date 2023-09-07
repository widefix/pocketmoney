# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublicAccountSharesController, type: :controller do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }

  describe '#show' do
    let!(:account_share) { create(:account_share, user: user, account: account) }

    subject(:show) { get :show, params: { token: account_share.token } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:show) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#new' do
    before { sign_in user }

    subject(:new) { get :new, params: { account_id: account.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    before { sign_in user }

    subject { post :create, params: { account_id: account.id } }

    it { is_expected.to redirect_to(account_shares_path) }
    it { is_expected.to have_http_status(302) }
    it { expect { subject }.to change { AccountShare.where(user_id: user.id).count }.by(1) }
    it { expect { subject }.to change { AccountShare.count }.by(1) }
  end
end
