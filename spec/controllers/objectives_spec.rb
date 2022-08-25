require "rails_helper"

RSpec.describe ObjectivesController, type: :controller do
  describe '#new' do
    let(:account) { create(:account, :parent) }

    subject(:new) { get :new, params: { account_id: account.id } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }    
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#create' do
    let(:account) { create(:account, :parent) }

    subject(:create) { post :create, params: { account_id: account.id, } }

    it { expect(response).to have_http_status(:success) }
  end
end