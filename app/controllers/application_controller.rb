class ApplicationController < ActionController::Base
  extend Memoist

  def params
    request.params
  end
end
