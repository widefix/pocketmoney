# frozen_string_literal: true

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

  helper_method memoize def top_up_time
    zone_name = ActiveSupport::TimeZone[Time.now.gmt_offset].name
    schedule = top_up_schedule
    top_up_utc_time = Time.now.utc.change(hour: schedule[:hour], min: schedule[:min])
    top_up_utc_time.in_time_zone(zone_name).strftime('%H:%M')
  end

  def top_up_schedule
    config = JSON.parse(File.read(Rails.root.join('app.json')))
    cron_index = config['cron'].find_index { |cron| cron['command'] == 'rake top_up_accounts' }
    raise IndexError, 'The top up accounts schedule not found' unless cron_index

    min, hour = config['cron'][cron_index]['schedule'].split[0..1]

    { hour: hour.to_i, min: min.to_i }
  end

  helper_method def current_url
    "https://budgetingkid.com#{request.path}"
  end
end
