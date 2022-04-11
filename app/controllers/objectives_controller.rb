class ObjectivesController < ApplicationController
  def destroy
    objective.destroy
    redirect_back(fallback_location: account_path(objective.account))
  end

  private

  helper_method memoize def objective
    # TODO: implement authZ
    Objective.find(ps.fetch(:id))
  end
end
