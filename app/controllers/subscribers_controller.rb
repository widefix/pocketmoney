class SubscribersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Subscriber.create!(email: params[:email])
  end
end
