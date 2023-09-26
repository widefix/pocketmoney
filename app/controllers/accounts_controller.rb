# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def new; end

  def edit; end

  def update
    if account.update(ps[:account])
      redirect_to account_path
    else
      render :edit
    end
  end

  def create
    ActiveRecord::Base.transaction do
      account = Account.create!(parent: current_user.account, **ps.slice(:name))

      automatic_topup_amount = ps[:automatic_topup].fetch(:amount)
      if automatic_topup_amount.present?
        AccountAutomaticTopupConfig.create!(from_account: current_user.account,
                                            to_account: account,
                                            amount: automatic_topup_amount)
      end
    end
    redirect_to my_account_path
  end

  def archive
    account = Account.visible_for_owner(current_user).unarchived.find(ps.fetch(:id))
    account.update!(archived_at: Time.current)
    redirect_to my_account_path
  end

  private

  helper_method memoize def account
    Account.visible_for(current_user).unarchived.find(ps.fetch(:id))
  end
end
