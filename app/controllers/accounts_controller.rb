# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def new
    @account = Account.new
    @account.automatic_topup_configs.build
  end

  def edit
  end

  def update
    if account.update(ps[:account])
      redirect_to account_path
    else
      render :edit
    end
  end

  def create
    params[:account][:automatic_topup_configs_attributes]['0'][:from_account_id] = current_user.account.id
    Account.create!(parent: current_user.account, **account_params)
    redirect_to my_account_path
  end

  private

  def account_params
    params.require(:account).permit(:name, automatic_topup_configs_attributes: %i[from_account_id amount])
  end

  helper_method memoize def account
    Account.visible_for(current_user).find(ps.fetch(:id))
  end
end
