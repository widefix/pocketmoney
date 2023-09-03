# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe '#create' do
    context 'when logs the user in' do
      let(:user) { create(:user) }
      subject { post :create, params: { user: { email: user.email, password: user.password } } }
      it { is_expected.to redirect_to(root_path) }
    end

    context 'when the user has not confirmed their email' do
      let(:user) { create(:user, confirmed_at: nil) }
      subject { post :create, params: { user: { email: user.email, password: user.password } } }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
