# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  GRATITUDE = <<-TEXT
    Thank you for providing us with your feedback. We greatly appreciate your input,
    and it helps us in our ongoing efforts to improve our application.
    If you have any further suggestions or comments, please feel free to share them.
  TEXT

  def new
    session[:current_url] = request.referer
  end

  def create
    feedback = current_user.feedbacks.new(user: current_user, **ps.slice(:description))
    return unless feedback.save

    flash.now.notice = GRATITUDE
    render :notification
  end
end
