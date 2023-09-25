# frozen_string_literal: true

class AcceptAccountSharesController < ApplicationController
  before_action :received_share, only: [:show], if: -> { user_signed_in? }

  def show
    return if user_signed_in?

    session[:after_sign_in_url] = request.fullpath

    shared_email = AccountShare.unaccepted.find_by!(token: ps.fetch(:token)).email
    user = User.find_by(email: shared_email)
    redirect_url = user ? new_user_session_url(email: shared_email) : new_user_registration_url(email: shared_email)

    redirect_to redirect_url
  end

  def update
    received_share.update!(accepted_at: Time.current)
    redirect_to account_path(received_share.account_id)
  end

  private

  helper_method memoize def received_share
    AccountShare.unaccepted.for(current_user).find_by!(token: ps.fetch(:token))
  end
end
