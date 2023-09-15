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

  private

  helper_method memoize def account
    Account.visible_for(current_user).find(ps.fetch(:id))
  end

  helper_method def weeks_to_goal(goal_amount, account)
    # y = f(x) = a*x + b, where y is the account balance in x days
    return unless approximation_coefficients(account).present?

    a, b = approximation_coefficients(account)
    days = (goal_amount - b) / a
    ((days - day_passed(account)) / 7).ceil
  end

  def approximation_coefficients(account)
    @approximation_coefficients ||= BalanceChangeApproximation.call(account)
  end

  def day_passed(account)
    @day_passed ||= (Time.current.to_date - account.created_at.to_date).to_i + 1
  end
end
