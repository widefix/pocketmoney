class MyAccountsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  private

  helper_method def accounts
    Account.select('accounts.*, users.email as user_email, users.id as user_id')
           .children_and_invitees(current_user)
           .joins('INNER JOIN users ON users.account_id = accounts.parent_id')
  end

  helper_method memoize def account
    current_user.account
  end
end
