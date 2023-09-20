# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    subject { get :index }

    context 'when a user is logged in' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(my_account_path) }
    end

    context 'when no user is logged in' do
      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:index) }
    end
  end
end
