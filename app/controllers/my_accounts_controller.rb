# frozen_string_literal: true

class MyAccountsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  private

  helper_method memoize def account
    current_user.account
  end

  helper_method memoize def shared_accounts
    Account.access_recipients(current_user)
  end
end
