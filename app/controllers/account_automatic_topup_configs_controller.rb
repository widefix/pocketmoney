class AccountAutomaticTopupConfigsController < ApplicationController
  def new
  end

  def create
    account.automatic_topup_configs.create!(
      from_account: current_user.account, **ps.slice(:amount)
    )
    redirect_to account_path(account)
  end

  private

  helper_method memoize def account
    Account.visible_for(current_user).find(ps.fetch(:account_id))
  end
end
