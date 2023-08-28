# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyAccountsController, type: :controller do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }

  describe '#show' do
    subject(:show) { get :show }

    before { sign_in user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:show) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#shared_accounts' do
    let(:invitee_user) { create(:user) }

    before do
      sign_in invitee_user
      create(:account_invitation, user: user, account: account, email: invitee_user.email, accepted_at: accepted_at)
    end
    context 'when invitation accepted' do
      let(:accepted_at) { Time.current }
      it { expect(controller.send(:shared_accounts, invitee_user)).to include(account) }
    end
    context 'when invitation unaccepted' do
      let(:accepted_at) { nil }
      it { expect(controller.send(:shared_accounts, invitee_user)).to be_empty }
    end
  end
end
