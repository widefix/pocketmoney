class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :account, optional: true
  has_many :feedbacks

  validates :name, allow_blank: true, length: { minimum: 2, maximum: 20 }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = find_me_by(data['email'])

    if user.nil?
      user = create_user_from_omniauth(data, access_token)
      user.create_user_account
    end
    user
  end

  def create_user_account
    create_account(name: name, email: email)
  end

  def self.find_me_by(email)
    User.find_by(email: email)
  end

  def self.create_user_from_omniauth(data, access_token)
    User.create(
      name: data['name'] || data['nickname'],
      email: data['email'],
      avatar_url: data['image'],
      password: Devise.friendly_token[0, 20],
      provider: access_token.provider
    )
  end
end
