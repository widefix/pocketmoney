# frozen_string_literal: true

class AccountAutomaticTopupConfigsController < ApplicationController
  def new; end

  def edit
    @account = Account.find(params[:account_id])
    @automatic_topup_config = @account.automatic_topup_configs.find(params[:id])
  end

  def create
    account.automatic_topup_configs.create!(
      from_account: current_user.account, **ps.slice(:amount)
    )
    redirect_to account_path(account)
  end

  def update
    account.automatic_topup_configs.find(ps[:id]).update!(amount: ps[:account_automatic_topup_config][:amount])
    redirect_to account_path(account)
  end

  def destroy
    account.automatic_topup_configs.find(ps[:id]).destroy
    redirect_to account_path(account), notice: 'Automatic topup config was successfully destroyed.'
  end
end
