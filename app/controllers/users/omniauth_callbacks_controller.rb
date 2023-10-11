# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      sign_in_and_redirect user, event: :authentication
    end

    private

    def user
      OmniauthAuthenticateAction.new(access_token: request.env['omniauth.auth']).perform
    end
  end
end
