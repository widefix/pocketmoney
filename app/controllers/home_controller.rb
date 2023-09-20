# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to my_account_path if user_signed_in?

    @budgeting_kid_reasons = YAML.load_file(Rails.root.join('config', 'budgeting_kid_reasons.yml'))['reasons']
  end
end
