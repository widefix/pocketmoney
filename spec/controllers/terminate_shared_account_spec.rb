# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TerminateSharedAccountController, type: :controller do
  describe '#update' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:another_user) { create(:user, account: account) }
    let(:terminating_account) { AccountShare.find(shared_account.id) }

    let!(:shared_account) do
      create(:account_share,
             user: user,
             account: account,
             email: another_user.email,
             accepted_at: Time.current)
    end

    subject do
      patch :update, params: { id: account.id }
    end

    before { sign_in another_user }

    it 'terminates the account' do
      subject
      expect(terminating_account.terminated?).to eq(true)
    end

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to my_account_path }
  end
end
