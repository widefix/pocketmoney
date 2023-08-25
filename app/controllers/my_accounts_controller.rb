class MyAccountsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  private

  helper_method memoize def account
    current_user.account
  end
end
