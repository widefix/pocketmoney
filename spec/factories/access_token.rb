# frozen_string_literal: true

FactoryBot.define do
  factory :access_token, class: OmniAuth::AuthHash do
    provider { 'google_oauth2' }
    uid { '12342' }
    info do
      {
        name: "is-#{FFaker::Name.name[0, 27]}",
        email: FFaker::Internet.email
      }
    end
  end
end
