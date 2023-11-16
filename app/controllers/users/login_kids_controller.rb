# frozen_string_literal: true

module Users
  class LoginKidsController < Devise::SessionsController
    def new; end

    def create
      account = Account.find_by(parents_key: ps[:parents_key])

      return unless account

      warden.authenticate!(:kid_user)

      redirect_to account_path(account)
    end
  end
end
