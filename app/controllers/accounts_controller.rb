class AccountsController < ApplicationController
  def show
  end

  private

  helper_method memoize def account
    Account.find(params.fetch(:id))
  end
end
