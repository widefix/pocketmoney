# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  default_form_builder BulmaFormBuilder
  extend Memoist

  def ps
    request.params
  end

  private

  helper_method def navbar_buttons_hide?
    return true if %w[sessions registrations].include?(controller_name) && action_name == 'new'
    return true if controller_name == 'wizards'

    false
  end

  helper_method def show_application_background?
    user_signed_in? && controller_name != 'wizards'
  end

  helper_method memoize def account
    Account.visible_for(current_user).unarchived.find(ps.fetch(:account_id))
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  helper_method memoize def goal_percentage(account, objective)
    ActionController::Base.helpers.number_to_percentage(account.balance / objective.amount * 100, precision: 0)
  end

  helper_method memoize def topup_utc_time
    Time.now.utc.change(hour: 14, min: 0).iso8601
  end

  helper_method def current_url
    "https://budgetingkid.com#{request.path}"
  end

  helper_method def avatar_for(person)
    if person.avatar.attached?
      url_for(person.avatar)
    else
      'user.svg'
    end
  end
end
