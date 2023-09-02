# frozen_string_literal: true

class AccountAutomaticTopupConfigsController < ApplicationController
  def new
    @automatic_topup_config = AccountAutomaticTopupConfig.new
  end

  def edit; end

  def create
    account.automatic_topup_configs.create!(from_account: current_user.account, amount: amount)
    redirect_to account_path(account)
  end

  def update
    automatic_topup_config.update!(amount: amount)
    redirect_to account_path(account)
  end

  def destroy
    automatic_topup_config.destroy
    redirect_to account_path(account)
  end

  private

  helper_method memoize def automatic_topup_config
    account.automatic_topup_configs.find(params[:id])
  end

  def amount
    ps[:account_automatic_topup_config][:amount]
  end
end
