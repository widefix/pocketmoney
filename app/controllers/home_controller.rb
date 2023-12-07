# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to my_account_path
  end
end
