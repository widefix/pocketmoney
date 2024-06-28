class Users::RegistrationsController < Devise::RegistrationsController
  layout 'initial_application', only: [:new]

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
      session[:after_sign_in_url] ||= new_account_wizard_path
    end
  end

  def edit_profile
    authenticate_scope!
    render :edit_profile
  end

  private

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def after_sign_up_path_for(resource)
    after_sign_in_url = session.delete(:after_sign_in_url)
    return after_sign_in_url if after_sign_in_url.present?

    super
  end
end
