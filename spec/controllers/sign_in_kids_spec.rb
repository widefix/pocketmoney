# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignInKidsController, type: :controller do
  let!(:parent_account) { create(:account, :parent) }
  let!(:account) { create(:account, :children, parent_id: parent_account.id) }
  let!(:parent_user) { create(:user, account: parent_account) }

  let(:parental_key) { SecureRandom.hex(3).upcase }

  describe '#new' do
    subject(:new) { get :new }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    subject { post :create, params: { parental_key: parental_key } }

    context 'when account_share exist' do
      let!(:account_share) { create(:account_share, user: parent_user, account: account, parental_key: parental_key) }

      it { is_expected.to redirect_to(account_path(account)) }
    end

    context 'when account_share not exist' do
      it { is_expected.not_to redirect_to(account_path(account)) }
    end
  end
end
