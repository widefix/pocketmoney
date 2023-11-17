# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    layout 'initial_application'

    def new
      if params.key?(:email)
        self.resource = User.new(email: params[:email])
      else
        super
      end
    end

    private

    def after_sign_in_path_for(_resource)
      after_sign_in_url = session.delete(:after_sign_in_url)
      return after_sign_in_url if after_sign_in_url.present?

      super
    end
  end
end
