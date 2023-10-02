class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :account, optional: true
  has_many :feedbacks

  validates :name, allow_blank: true, length: { minimum: 2, maximum: 20 }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])

    user ||= User.create(
      name: data['name'] || data['nickname'],
      email: data['email'],
      avatar: data['image'],
      password: Devise.friendly_token[0, 20],
      provider: access_token.provider
    )
    user
  end
end
