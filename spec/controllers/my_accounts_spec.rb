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
    let(:shared_user) { create(:user) }

    before do
      sign_in shared_user
      create(:account_share, user: user, account: account, email: shared_user.email, accepted_at: accepted_at)
    end
    context 'when account share accepted' do
      let(:accepted_at) { Time.current }
      it { expect(controller.send(:shared_accounts, shared_user)).to include(account) }
    end
    context 'when account share unaccepted' do
      let(:accepted_at) { nil }
      it { expect(controller.send(:shared_accounts, shared_user)).to be_empty }
    end
  end
end
