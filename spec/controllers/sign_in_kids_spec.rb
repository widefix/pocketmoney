# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignInKidsController, type: :controller do
  let!(:parent_account) { create(:account, :parent) }
  let!(:account) { create(:account, :children, parental_key: parental_key, parent_id: parent_account.id) }
  let!(:user) { create(:user, account: parent_account) }
  let!(:kids_account) { create(:account, :parent) }
  let!(:kids_user) { create(:user, account: kids_account, parental_key: parental_key) }
  let!(:account_share) { create(:account_share, user: user, account: account, parental_key: parental_key) }

  let(:parental_key) { SecureRandom.hex(3).upcase }

  describe '#new' do
    subject(:index) { get :new }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    subject { post :create, params: { parental_key: parental_key } }

    context "when kid's user exist" do
      it { is_expected.to redirect_to(account_path(account)) }
    end

    context "when kid's user not exist" do
      let!(:kids_user) { create(:user, account: kids_account, parental_key: parental_key, blocked_at: Time.current) }

      it { is_expected.not_to redirect_to(account_path(account)) }
    end
  end
end
