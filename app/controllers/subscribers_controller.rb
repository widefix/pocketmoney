class SubscribersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    headers['Access-Control-Allow-Origin'] = 'https://get.budgetingkid.com'
    headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS'
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type'
      render plain: '', content_type: 'text/plain'
    else
      Subscriber.create!(email: params[:email])
    end
  end
end
