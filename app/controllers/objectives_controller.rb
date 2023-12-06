class ObjectivesController < ApplicationController
  def new
  end

  def create
    account.objectives.create!(ps.slice(:name, :amount))
    redirect_to account_path(account)
  end

  def destroy
    objective.destroy
    redirect_back(fallback_location: account_path(objective.account))
  end

  def accomplish
    objective.update(accomplished_at: Time.current)
    redirect_to account_path(objective.account, anchor: 'desktop-goals')
  end

  private

  helper_method memoize def objective
    # TODO: implement authZ
    Objective.find(ps.fetch(:id))
  end
end
