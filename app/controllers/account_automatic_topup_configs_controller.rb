class AccountAutomaticTopupConfigsController < ApplicationController
  def new
  end

  def create
    account.automatic_topup_configs.create!(
      from_account: current_user.account, **ps.slice(:amount)
    )
    redirect_to account_path(account)
  end
end
