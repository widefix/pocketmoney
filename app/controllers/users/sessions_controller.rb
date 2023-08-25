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

    protected

    def after_sign_in_path_for(_resource)
      if (token = session.delete(:token)).present?
        return accept_account_invitation_path(token: token)
      end

      super
    end
  end
end
