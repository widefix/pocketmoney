# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe '#google_oauth2' do
    context 'when the user exists' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, info: { name: user.name, email: user.email }) }

      it 'logs in the user' do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = access_token
        get :google_oauth2

        expect(controller.current_user).to eq(user)
      end
    end

    context 'when the user is new' do
      let(:access_token) { create(:access_token) }

      it 'signs up the user' do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = access_token
        get :google_oauth2

        expect(controller.current_user.email).to eq(access_token.info.email)
      end
    end
  end
end
