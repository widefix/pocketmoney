# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChooseRoleController, type: :controller do
  describe '#index' do
    subject(:index) { get :index }

    context 'when user is signed in' do
      let!(:account) { create(:account, :parent) }
      let!(:user) { create(:user, account: account) }

      before { sign_in user }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(my_account_path) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:index) }
    end
  end
end
