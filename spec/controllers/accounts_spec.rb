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
      { name: account.name, automatic_topup: {amount: 10 }}
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
    subject(:update) { patch :update, params: { id: account, account: attributes } }

    context 'with valid params' do
      let(:new_name) { FFaker::Name.first_name }
      let(:attributes) {{ name: new_name }}

      it { is_expected.to have_http_status(:redirect) }
    end

    context 'with invalid params' do
      let(:attributes) {{ name: nil }}

      it { expect(subject).not_to be_redirect }
    end

    context 'with notification and email' do
      let(:attributes) {{ notification: true, email: FFaker::Internet.email }}

      it { is_expected.to have_http_status(:redirect) }
    end

    context 'with notification and empty email' do
      let(:account) { create(:account, :with_notify) }
      let(:attributes) {{ notification: true, email: '' }}

      it { expect(subject).not_to be_redirect }
    end
  end

  describe '#update_timeframe' do
    subject(:update_timeframe) { patch :update_timeframe, params: { id: account, account: attributes } }

    context 'with valid params' do
      let(:attributes) {{ accumulative_balance_timeframe: 'week' }}

      it { is_expected.to have_http_status(:redirect) }
      it { expect { subject }.to change { account.reload.accumulative_balance_timeframe }.to('week') }
    end
  end

  describe '#archive' do
    subject(:archive) { get :archive, params: { id: account } }

    context 'when the current user owns the account' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(my_account_path) }
      it { expect { subject }.not_to(change { Account.count }) }
      it { expect { subject }.to change { account.reload.archived_at }.from(nil) }
    end

    context 'when the current user does not own the account' do
      let(:other_account) { create(:account, :parent) }
      let(:other_user) { create(:user, account: other_account) }

      before { sign_in other_user }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when the current user is received share' do
      let(:other_account) { create(:account, :parent) }
      let(:other_user) { create(:user, account: other_account) }

      before do
        create(:account_share, user: user, account: account, email: other_user.email, accepted_at: Time.current)
        sign_in other_user
      end

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
