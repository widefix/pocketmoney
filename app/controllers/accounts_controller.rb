# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def new; end

  def edit; end

  def update
    attach_avatar_for(account)
    ActiveRecord::Base.transaction do
      account.update!(ps[:account])
      update_kids_info unless current_user.parent?
    end
    redirect_to account_path
  rescue ActiveRecord::ActiveRecordError
    render :edit
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

  def update_kids_info
    account_params = params.require(:account).permit(:name, :email)
    current_user.update!(account_params)
    current_user.account.update!(account_params)
    account.account_shares.find { |share| share.parental_key == current_user.parental_key }.update!(account_params)
  end

  def attach_avatar_for(account)
    image_params = params.fetch(:avatar, params.dig(:account, :avatar))
    account.avatar.attach(image_params) if image_params.present?
  end

  helper_method memoize def account
    Account.visible_for(current_user).unarchived.find(ps.fetch(:id))
  end
end
