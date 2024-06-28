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

  describe '#update' do
    before { sign_in user }

    let(:password) { FFaker::Internet.password }
    let(:new_password) { FFaker::Internet.password }
    let(:user) { create(:user, password: password) }
    let(:new_email) { FFaker::Internet.email }

    subject { put :update, params: { id: user.id, user: { email: new_email } } }

    it { expect(subject).to have_http_status(:redirect) }
    it { expect { subject }.to change { user.reload.email }.to(new_email) }

    it { expect { put :update, params: { id: user.id, user: { name: new_email } } }.to change { user.reload.name }.to(new_email) }
    it { expect { put :update, params: { id: user.id, user: { name: new_email, password: '' } } }.to change { user.reload.name }.to(new_email) }
    it {
      expect do
        put :update, params: { id: user.id, user: { password: new_password, password_confirmation: new_password } }
      end.to change { user.reload.valid_password?(new_password) }.from(false).to(true)
    }

    it {
      expect do
        put :update, params: { id: user.id, user: { password: '', password_confirmation: new_password } }
      end.to_not change { user.reload.valid_password?(new_password) }.from(false)
    }
  end
end
