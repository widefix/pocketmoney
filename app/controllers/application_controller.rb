class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  default_form_builder BulmaFormBuilder
  extend Memoist

  def ps
    request.params
  end

  private

  helper_method memoize def account
    Account.visible_for(current_user).unarchived.find(ps.fetch(:account_id))
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  helper_method memoize def goal_percentage(account, objective)
    ActionController::Base.helpers.number_to_percentage(account.balance / objective.amount * 100, precision: 0)
  end

  helper_method def canonical_path
    (url_for(only_path: true) if [:home, :policy].include?(params[:controller])) || ''
  end
end
