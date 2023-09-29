# frozen_string_literal: true

require "rails_helper"

RSpec.describe ObjectivesController, type: :controller do
  describe '#new' do
    let(:account) { create(:account, :parent) }

    subject(:new) { get :new, params: { account_id: account } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }    
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#create' do
    let(:account) { create(:account, :parent) }

    subject(:create) { post :create, params: { account_id: account } }

    it { expect(response).to have_http_status(:success) }
  end

  describe '#destroy' do
    let!(:account) { create(:account, :parent) }
    let!(:objective) { create(:objective, account: account) }

    subject(:destroy) { delete :destroy, params: { id: objective.id } }

    it { is_expected.to have_http_status(:redirect) }
    it { is_expected.to redirect_to(account_path(account)) }
    it { expect { subject }.to change { Objective.count }.by(-1) }
  end
end
