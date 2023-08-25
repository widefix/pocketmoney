class Users::RegistrationsController < Devise::RegistrationsController
  def new
    if params.key?(:email)
      self.resource = User.new(email: params[:email])
    else
      super
    end
  end

  def create
    super do |user|
      user.create_account(name: user.email, email: user.email) if user.persisted?
    end
  end

  protected

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private

  def after_sign_up_path_for(resource)
    after_authentication_url = session.delete(:after_authentication_url)
    return after_authentication_url if after_authentication_url.present?

    super
  end
end