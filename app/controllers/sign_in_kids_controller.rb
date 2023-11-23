# frozen_string_literal: true

class SignInKidsController < ApplicationController
  layout 'initial_application'

  def new; end

  def create
    account = Account.find_by(parental_key)
    return if !account || account.account_shares.none? { |share| share.parental_key == ps[:parental_key].upcase }

    user = User.find_by(parental_key)
    sign_in user
    redirect_to account_path(account)
  end

  private

  memoize def parental_key
    { parental_key: ps[:parental_key].upcase }
  end
end
