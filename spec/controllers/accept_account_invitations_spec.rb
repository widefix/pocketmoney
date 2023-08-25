# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AcceptAccountInvitationsController, type: :controller do
  describe '#show' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:second_user) { create(:user, account: account) }

    let!(:account_invitation) { create(:account_invitation, user: user, account: account, email: second_user.email) }

    subject do
      get :show, params: { token: account_invitation.token }
    end

    before { sign_in second_user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe '#update' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:second_user) { create(:user, account: account) }

    let!(:account_invitation) { create(:account_invitation, user: user, account: account, email: second_user.email) }

    subject do
      patch :update, params: { token: account_invitation.token }
    end

    before { sign_in second_user }

    it 'set the taime' do
      subject
      expect(AccountInvitation.find(account_invitation.id).accepted_at).not_to be_nil
    end
    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to(account_path(account_invitation.account_id)) }
  end
end
