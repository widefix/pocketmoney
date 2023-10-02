# frozen_string_literal: true

class ArchivedAccountsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def restore
    archived_account.update!(archived_at: nil)
    redirect_to archived_accounts_path
  end

  private

  helper_method memoize def archived_accounts
    Account.visible_for_owner(current_user).archived
  end

  helper_method memoize def archived_account
    archived_accounts.find(ps.fetch(:id))
  end
end
