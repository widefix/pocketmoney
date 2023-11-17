# frozen_string_literal: true

class WizardsController < ApplicationController
  before_action :authenticate_user!
  layout 'initial_application'

  def new_account; end

  def new_automatic_topup; end

  def new_objective; end

  def new_share_account; end

  def create_account
    Account.create!(parent: current_user.account, **ps.slice(:name))

    redirect_to new_automatic_topup_wizard_path
  end

  def create_automatic_topup
    AccountAutomaticTopupConfig.create!(from_account: current_user.account,
                                        to_account: account,
                                        **ps.slice(:amount))

    redirect_to new_objective_wizard_path
  end

  def create_objective
    account.objectives.create!(ps.slice(:name, :amount))

    redirect_to new_share_account_wizard_path
  end

  def create_share_account
    account_share = AccountShare.create!(user_id: current_user.id,
                                         account_id: account.id,
                                         token: SecureRandom.urlsafe_base64(32),
                                         **ps.slice(:name, :email))

    AccountShareMailer.account_share(account_share).deliver

    redirect_to account_path(account)
  end

  private

  helper_method memoize def account
    current_user.account.children.first
  end
end
