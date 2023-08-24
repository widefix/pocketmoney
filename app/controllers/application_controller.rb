class ApplicationController < ActionController::Base
  default_form_builder BulmaFormBuilder
  extend Memoist

  def ps
    request.params
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  private

  helper_method memoize def account
    Account.visible_for(current_user).find(ps.fetch(:account_id))
  end
end
