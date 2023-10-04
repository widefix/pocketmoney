# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe '#google_oauth2' do
    let(:user) { create(:user) }
    let(:omniauth_data) do
      OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12342',
        info: {
          name: 'Sam Hunt',
          email: 'sam.hunt@example.com',
          image: 'https://example.com/sam_hunt_54418669756445476.png'
        }
      )
    end

    subject { get :google_oauth2, params: { provider: 'google_oauth2' } }

    before do
      OmniAuth.config.test_mode = true
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = omniauth_data
      allow(User).to receive(:from_omniauth).and_return(user)
    end

    it 'calls User.from_omniauth with the correct omniauth data' do
      expect(User).to receive(:from_omniauth).with(omniauth_data).and_return(user)
      get :google_oauth2
    end

    it 'should sign in the user' do
      subject

      expect(controller.current_user).to be_present
    end

    it 'should redirect the user' do
      subject

      expect(response).to redirect_to(root_path)
    end
  end
end
