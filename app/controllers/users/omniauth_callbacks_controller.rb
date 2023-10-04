# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      sign_in_and_redirect user, event: :authentication
    end

    private

    def user
      User.from_omniauth(request.env['omniauth.auth'])
    end
  end
end
