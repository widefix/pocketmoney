# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KidAccountSharesController, type: :controller do
  let!(:account) { create(:account, :parent, parental_key: parental_key) }
  let!(:user) { create(:user, account: account) }
  let!(:kids_account) { create(:account, :parent) }

  let(:parental_key) { SecureRandom.hex(3).upcase }

  before { sign_in user }

  describe '#new' do
    subject(:index) { get :new, params: { account_id: account.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    subject { post :create, params: { account_id: account.id } }

    context "when kid's user not exist" do
      before { account.update_attribute(:parental_key, nil) }

      it { is_expected.to redirect_to(account_shares_path) }
      it { expect { subject }.to change { AccountShare.where(user_id: user.id).count }.by(1) }
      it { expect { subject }.to change { AccountShare.count }.by(1) }
      it { expect { subject }.to change { User.count }.by(1) }
      it { expect { subject }.to change { Account.count }.by(1) }
      it { expect { subject }.to change { account.reload.parental_key }.from(nil) }
    end

    context "when kid's user already exist" do
      let!(:kids_user) { create(:user, account: kids_account, parental_key: parental_key, blocked_at: Time.current) }

      it { is_expected.to redirect_to(account_shares_path) }
      it { expect { subject }.to change { AccountShare.count }.by(1) }
      it { expect { subject }.not_to(change { User.count }) }
      it { expect { subject }.to change { kids_user.reload.parental_key }.from(parental_key) }
      it { expect { subject }.to change { kids_user.reload.blocked_at }.to(nil) }
      it { expect { subject }.not_to(change { Account.count }) }
      it { expect { subject }.to(change { account.reload.parental_key }) }
    end
  end

  describe '#destroy' do
    let!(:kids_user) { create(:user, account: kids_account, parental_key: parental_key) }
    let!(:account_share) { create(:account_share, user: user, account: account, parental_key: parental_key) }

    subject { delete :destroy, params: { account_id: account.id, id: account_share, parental_key: parental_key } }

    context 'when user have access to destroy the share' do
      it { expect { subject }.to change { AccountShare.count }.by(-1) }
      it { is_expected.to redirect_to(account_shares_path) }
      it { expect { subject }.not_to(change { User.count }) }
      it { expect { subject }.to change { kids_user.reload.blocked_at }.from(nil) }
      it { expect { subject }.not_to(change { Account.count }) }
    end
  end
end
