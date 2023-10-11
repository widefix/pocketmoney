# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetUserFromOmniauthAction, type: :action do
  describe '#perform_implementation' do
    context 'when the user exists' do
      let!(:user) { create(:user) }
      let(:existing_user_token) { create(:access_token, info: { name: user.name, email: user.email }) }

      subject(:action) { described_class.new(access_token: existing_user_token) }

      it { expect { action.perform }.to change { User.count }.by(0) }
      it { expect { action.perform }.to change { Account.count }.by(0) }
    end

    context 'when new user sings up' do
      let(:new_user_token) { create(:access_token) }

      subject(:action) { described_class.new(access_token: new_user_token) }

      it { expect { action.perform }.to change { User.count }.by(1) }
      it { expect { action.perform }.to change { Account.count }.by(1) }
    end
  end
end
