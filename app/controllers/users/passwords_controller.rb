# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    layout 'initial_application', only: [:new, :edit]
  end
end
