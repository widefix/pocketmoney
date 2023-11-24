# frozen_string_literal: true

class SignInKidsController < ApplicationController
  layout 'initial_application'

  def new; end

  def create
    account_share = AccountShare.includes(:account).find_by(parental_key: ps[:parental_key].upcase)
    return unless account_share

    sign_in KidsUserService.new(account_share).perform

    redirect_to account_path(account_share.account) if current_user.present?
  end
end
