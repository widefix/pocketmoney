# frozen_string_literal: true

class MyAccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to account_path(shared_accounts.accepted.first) unless current_user.parent?
  end

  private

  helper_method memoize def account
    current_user.account
  end

  helper_method memoize def shared_accounts
    Account.unarchived.shared_for(current_user)
  end

  helper_method memoize def unaccepted_shares
    AccountShare.visible.unaccepted.for(current_user)
  end

  helper_method memoize def archived_accounts
    Account.visible_for_owner(current_user).archived
  end
end
