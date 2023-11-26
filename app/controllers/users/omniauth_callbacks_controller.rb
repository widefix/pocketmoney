# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include Devise::Controllers::Rememberable

    def google_oauth2
      remember_me user
      sign_in_and_redirect user, event: :authentication
    end

    def facebook
      remember_me user
      sign_in_and_redirect user, event: :authentication
    end

    private

    memoize def user
      OmniauthAuthenticateAction.new(access_token: request.env['omniauth.auth']).perform
    end
  end
end
