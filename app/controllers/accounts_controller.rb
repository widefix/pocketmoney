class AccountsController < ApplicationController
  def show
  end

  private

  helper_method memoize def account
    params.fetch(:id)
  end
end
