# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WizardsController, type: :controller do
  let!(:account) { create(:account, :parent) }
  let!(:user) { create(:user, account: account) }

  before { sign_in user }

  describe '#new_account' do
    subject(:new_account) { get :new_account }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new_account) }
  end

  describe '#new_automatic_topup' do
    subject(:new_automatic_topup) { get :new_automatic_topup }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new_automatic_topup) }
  end

  describe '#new_objective' do
    subject(:new_objective) { get :new_objective }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new_objective) }
  end

  describe '#create_account' do
    subject(:create_account) { post :create_account, params: { name: FFaker::Name.first_name } }

    it { expect { subject }.to change { Account.count }.by(1) }
    it { is_expected.to redirect_to(new_automatic_topup_wizard_path) }
  end

  describe '#create_automatic_topup' do
    let!(:child) { create(:account, :children, parent: account) }

    subject(:create_automatic_topup) { post :create_automatic_topup, params: { amount: FFaker::Number.number } }

    it { expect { subject }.to change { AccountAutomaticTopupConfig.count }.by(1) }
    it { is_expected.to redirect_to(new_objective_wizard_path) }
  end

  describe '#create_objective' do
    let!(:child) { create(:account, :children, parent: account) }

    subject(:create_objective) do
      post :create_objective, params: { name: FFaker::Book.title, amount: FFaker::Number.number }
    end

    it { expect { subject }.to change { Objective.count }.by(1) }
    it { is_expected.to redirect_to(account_path(child)) }
  end
end
