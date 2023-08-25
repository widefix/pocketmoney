# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyAccountsController, type: :controller do
  describe '#show' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    subject(:show) { get :show }

    before { sign_in user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:show) }
    it { is_expected.to_not render_template('home/index') }
  end
end
