class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  default_form_builder BulmaFormBuilder
  extend Memoist

  def ps
    request.params
  end

  private

  helper_method memoize def account
    Account.visible_for(current_user).find(ps.fetch(:account_id))
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
