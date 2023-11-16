# frozen_string_literal: true

class KidUserStrategy < Devise::Strategies::Base
  def valid?
    params[:parents_key].present?
  end

  def authenticate!
    kid_user = User.new(parents_key: params[:parents_key])
    success!(kid_user)
  end
end
