class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      user.create_account(name: user.email, email: user.email) if user.persisted?
    end
  end

  protected

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end