# frozen_string_literal: true

class ChooseRoleController < ApplicationController
  layout 'initial_application'

  def index
    redirect_to my_account_path if user_signed_in?
  end
end
