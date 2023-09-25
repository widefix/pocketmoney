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
      it { expect(controller.send(:shared_accounts)).to include(account) }
    end
    context 'when account share unaccepted' do
      let(:accepted_at) { nil }
      it { expect(controller.send(:shared_accounts)).to be_empty }
    end

    context 'when account archived' do
      let!(:account) { create(:account, :parent, archived_at: Time.current) }

      let(:accepted_at) { nil }
      it { expect(controller.send(:shared_accounts)).to be_empty }
    end
  end

  describe '#unaccepted_shares' do
    let(:shared_user) { create(:user) }
    let!(:account_share) { create(:account_share, user: user, account: account, email: shared_user.email, accepted_at: accepted_at) }

    before { sign_in shared_user }

    context 'when account share accepted' do
      let(:accepted_at) { Time.current }
      it { expect(controller.send(:unaccepted_shares)).to be_empty }
    end

    context 'when account share unaccepted' do
      let(:accepted_at) { nil }
      it { expect(controller.send(:unaccepted_shares)).to include(account_share) }
    end

    context 'when account archived' do
      let!(:account) { create(:account, :parent, archived_at: Time.current) }

      let(:accepted_at) { nil }
      it { expect(controller.send(:unaccepted_shares)).to be_empty }
    end
  end
end
