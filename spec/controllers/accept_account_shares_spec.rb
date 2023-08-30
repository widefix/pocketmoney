# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AcceptAccountSharesController, type: :controller do
  describe '#show' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:second_user) { create(:user) }

    let!(:account_share) { create(:account_share, user: user, account: account, email: second_user.email) }

    subject do
      get :show, params: { token: account_share.token }
    end

    context 'when the user not signed in' do
      it 'redirects to new user session url with email' do
        subject
        expect(response).to redirect_to(new_user_session_url(email: account_share.email))
      end
    end

    context 'when the user not signed up' do
      let(:account_share) { create(:account_share, user: user, account: account) }

      it 'redirects to registration url with email' do
        subject
        expect(response).to redirect_to(new_user_registration_url(email: account_share.email))
      end
    end

    context 'when the user signed in' do
      before { sign_in second_user }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:show) }
    end
  end

  describe '#update' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:second_user) { create(:user, account: account) }

    let!(:account_share) { create(:account_share, user: user, account: account, email: second_user.email) }

    subject do
      patch :update, params: { token: account_share.token }
    end

    before { sign_in second_user }

    it 'set the taime' do
      subject
      expect(AccountShare.find(account_share.id).accepted_at).not_to be_nil
    end
    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to(account_path(account_share.account_id)) }
  end
end
