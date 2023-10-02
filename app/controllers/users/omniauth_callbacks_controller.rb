# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :set_account

    def google_oauth2
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
        redirect_to new_user_registration_url
      end
    end

    private

    def set_account
      @user = User.from_omniauth(request.env['omniauth.auth'])
    end
  end
end