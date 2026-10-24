# frozen_string_literal: true

class HealthController < ApplicationController
  def show
    render json: {
      status: 'ok',
      timestamp: Time.current.iso8601,
      version: Rails.version
    }
  end
end
