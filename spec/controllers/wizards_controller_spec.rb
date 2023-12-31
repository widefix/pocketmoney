# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WizardsController, type: :controller do
  let!(:account) { create(:account, :parent) }
  let!(:user) { create(:user, account: account) }

  describe '#new_account' do
    subject(:new_account) { get :new_account }

    context 'when user is signed in' do
      before { sign_in user }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:new_account) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe '#new_automatic_topup' do
    subject(:new_automatic_topup) { get :new_automatic_topup }

    context 'when user is signed in' do
      before { sign_in user }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:new_automatic_topup) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe '#new_objective' do
    subject(:new_objective) { get :new_objective }

    context 'when user is signed in' do
      before { sign_in user }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:new_objective) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe '#new_share_account' do
    subject(:new_share_account) { get :new_share_account }

    context 'when user is signed in' do
      before { sign_in user }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:new_share_account) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe '#create_account' do
    subject(:create_account) { post :create_account, params: { name: FFaker::Name.first_name } }

    context 'when user is signed in' do
      before { sign_in user }

      it { expect { subject }.to change { Account.count }.by(1) }
      it { is_expected.to redirect_to(new_automatic_topup_wizard_path) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe '#create_automatic_topup' do
    let!(:child) { create(:account, :children, parent: account) }

    subject(:create_automatic_topup) { post :create_automatic_topup, params: { amount: FFaker::Number.number } }

    context 'when user is signed in' do
      before { sign_in user }

      it { expect { subject }.to change { AccountAutomaticTopupConfig.count }.by(1) }
      it { is_expected.to redirect_to(new_objective_wizard_path) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe '#create_objective' do
    let!(:child) { create(:account, :children, parent: account) }

    subject(:create_objective) do
      post :create_objective, params: { name: FFaker::Book.title, amount: FFaker::Number.number }
    end

    context 'when user is signed in' do
      before { sign_in user }

      it { expect { subject }.to change { Objective.count }.by(1) }
      it { is_expected.to redirect_to(new_share_account_wizard_path) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe '#create_share_account' do
    let!(:child) { create(:account, :children, parent: account) }

    subject(:create_share_account) do
      post :create_share_account, params: { name: FFaker::Book.title, email: FFaker::Internet.email }
    end

    context 'when user is signed in' do
      before { sign_in user }

      it { expect { subject }.to change { AccountShare.count }.by(1) }
      it { is_expected.to redirect_to(account_path(child)) }
    end

    context 'when user is not signed in' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
