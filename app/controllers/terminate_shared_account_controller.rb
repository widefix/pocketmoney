# frozen_string_literal: true

class TerminateSharedAccountController < ApplicationController
  def update
    terminating_account.update!(accepted_at: DateTime.new(0))
    redirect_to my_account_path
  end

  private

  def terminating_account
    AccountShare.accepted.for(current_user).find_by!(account_id: ps.fetch(:id))
  end
end
