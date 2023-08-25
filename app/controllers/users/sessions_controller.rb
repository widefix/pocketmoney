# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def new
      if params.key?(:email)
        self.resource = User.new(email: params[:email])
      else
        super
      end
    end

    private

    def after_sign_in_path_for(_resource)
      after_authentication_url = session.delete(:after_authentication_url)
      return after_authentication_url if after_authentication_url.present?

      super
    end
  end
end
