class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account, optional: true # needs to be created after the user gets created

  after_create :create_account

  private

  def create_account
    update!(account: Account.find_or_create_by!(name: email))
  end
end
