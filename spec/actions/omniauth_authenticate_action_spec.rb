# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OmniauthAuthenticateAction, type: :action do
  describe '#perform_implementation' do
    let(:user) { create(:user) }
    subject(:action) { described_class.new(access_token: access_token) }

    context 'when the user exists' do
      let!(:access_token) { create(:access_token, info: { name: user.name, email: user.email }) }

      it { expect { action.perform }.to change(User, :count).by(0) }
      it { expect { action.perform }.to change(Account, :count).by(0) }
    end

    context 'when new user sings up' do
      let!(:access_token) { create(:access_token) }

      it { expect { action.perform }.to change(User, :count).by(1) }
      it { expect { action.perform }.to change(Account, :count).by(1) }
    end
  end
end
