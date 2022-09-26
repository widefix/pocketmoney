require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe '#create' do
    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }
    let(:created_user) { User.find_by(email: email) }
    let(:created_account) { Account.find_by(email: created_user.email) }

    subject { post :create, params: { user: { email: email, password: password } } }

    it { expect { subject }.to change { User.where(email: email).count }.by(1) }
    it { expect { subject }.to change { Account.where(email: email).count }.by(1) }
    it { is_expected.to have_http_status(:redirect) }
    it { subject; expect(created_user.account).to be_present }
    it { subject; expect(created_user).to have_attributes(email: email) }
    it { subject; expect(created_account).to have_attributes(name: email, email: email) }
    it { subject; expect(created_user.account).to eq(created_account) }
  end
end