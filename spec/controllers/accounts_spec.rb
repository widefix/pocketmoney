# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }

  before { sign_in user }

  describe '#show' do
    subject(:show) { get :show, params: {id: account } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:show) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#new' do
    subject(:new) { get :new }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
    it { is_expected.to_not render_template('accounts/show') }
  end

  describe '#create' do
    let(:valid_params) do
      { account: { parent: account, name: account.name,
                   automatic_topup_configs_attributes: {
                     '0': {amount: 10, from_account_id: user.account.id }
                   }}}
    end
    subject { post :create, params: valid_params}

    it { is_expected.to redirect_to(my_account_path) }
    it { is_expected.to have_http_status(302) }
    it { expect { subject }.to change { Account.where(name: account.name).count }.by(1) }
    it { expect { subject }.to change { Account.count }.by(1) }
  end

  describe '#edit' do
    subject(:edit) { get :edit, params: { id: account }}

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:edit) }
    it { is_expected.to_not render_template(:new) }
  end

  describe '#update' do
    let(:name) { FFaker::Name.first_name }
    let(:old_name) { old_name = account.name }

    subject(:bad_update) { patch :update, params: { id: user.account, account: { name: nil }} }
    subject(:update) { patch :update, params: { id: user.account, account: { name: name }} }

    it { is_expected.to have_http_status(:redirect) }
    it { expect(bad_update).not_to be_redirect }
    it 'name changed' do
      expect(Account.where(id: account.id).name).not_to eq(old_name)
    end
  end
end