class AccountsController < ApplicationController
  def show
  end

  def new
  end

  def edit
  end

  def update
    if account.update(ps[:account])
      redirect_to account_path
    else
      render :edit
    end
  end

  def create
    Account.create!(parent: current_user.account, **ps.slice(:name))
    redirect_to my_account_path
  end

  private

  memoize def public_shared_accounts
    Set.new(AccountShare.accepted.for_public.pluck(:account_id))
  end

  helper_method memoize def public_share?(account)
    public_shared_accounts.include?(account.id)
  end

  helper_method memoize def account
    Account.visible_for(current_user).find(ps.fetch(:id))
  end
end
