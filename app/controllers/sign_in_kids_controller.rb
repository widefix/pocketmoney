# frozen_string_literal: true

class SignInKidsController < ApplicationController
  def new; end

  def create
    account = Account.find_by(parents_key)
    return unless account

    user = User.find_by(parents_key)
    sign_in user
    redirect_to account_path(account, parents_key)
  end

  private

  memoize def parents_key
    { parents_key: ps[:parents_key] }
  end
end
