class ApplicationController < ActionController::Base
  default_form_builder BulmaFormBuilder
  extend Memoist

  def ps
    request.params
  end
end
