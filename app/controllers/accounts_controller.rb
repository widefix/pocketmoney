# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def new; end

  def edit; end

  def update
    attach_avatar_for(account)
    attach_background_for(account)
    if account.update(ps[:account])
      redirect_to account_path
    else
      render :edit
    end
  end

  def update_timeframe
    account.update(accumulative_balance_timeframe: ps[:account].fetch(:accumulative_balance_timeframe))
    redirect_to account_path(anchor: 'chart')
  end

  def create
    ActiveRecord::Base.transaction do
      account = Account.create!(parent: current_user.account, **ps.slice(:name))
      attach_avatar_for(account)
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

  def attach_avatar_for(account)
    image_params = params.fetch(:avatar, params.dig(:account, :avatar))
    account.avatar.attach(image_params) if image_params.present?
  end

  def attach_background_for(account)
    background_params = params.fetch(:background, params.dig(:account, :background))
    account.background.attach(background_params) if background_params.present?
  end

  helper_method memoize def account
    Account.visible_for(current_user).unarchived.find(ps.fetch(:id))
  end
end
