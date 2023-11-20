# frozen_string_literal: true

class SignInKidsController < ApplicationController
  def new; end

  def create
    account = Account.find_by(parents_key: ps[:parents_key])
    user = User.find_by(parents_key: ps[:parents_key])
    sign_in user
    redirect_to account_path(account, parents_key: ps[:parents_key]) if account
  end
end
