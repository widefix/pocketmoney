class ApplicationController < ActionController::Base
  extend Memoist

  def ps
    request.params
  end
end
