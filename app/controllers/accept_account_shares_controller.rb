# frozen_string_literal: true

class AcceptAccountSharesController < ApplicationController
  def show
    if user_signed_in?
      return render_notification("You can't accept, because you are the owner") if user_is_owner?
      return render_notification('Already accepted') if received_share.accepted_at.present?

      return
    end

    session[:after_sign_in_url] = request.fullpath

    shared_email = received_share.email
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
    AccountShare.find_by!(token: ps.fetch(:token))
  end

  def render_notification(message)
    flash.now.notice = message
    render :notification
  end

  def user_is_owner?
    current_user.id == received_share.user_id
  end
end
