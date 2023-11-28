# frozen_string_literal: true

class UpdateAccountService
  def initialize(account, params)
    @account = account
    @params = params
    @account_share = @account.account_shares.where.not(parental_key: nil).first

    return unless @account_share

    @kid_user = User.includes(:account).find_by(parental_key: @account_share.parental_key)
    @kid_account = @kid_user&.account
  end

  def perform
    return false if email_already_exists?(@params[:email])

    attributes = @params.slice(:name, :email).reject { |_, v| v.blank? }

    ActiveRecord::Base.transaction do
      update_records(attributes)
      true
    end
  rescue ActiveRecord::ActiveRecordError
    false
  end

  private

  def email_already_exists?(email)
    return false unless email.present?

    user = User.find_by(email: email)
    user.present? && (user.parental_key.nil? || user.parental_key != @account_share&.parental_key)
  end

  def update_records(attributes)
    @account.update!(@params)
    @account_share&.update!(attributes)
    @kid_user&.update!(attributes)
    @kid_account&.update!(attributes)
  end
end
