require 'rails_helper'

RSpec.describe AccountInvitationsController, type: :controller do
  describe '#index' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    subject(:index) { get :index, params: { account_id: account.id } }

    before { sign_in user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe '#new' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    subject(:new) { get :new, params: { account_id: account.id } }

    before { sign_in user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    subject do
      post :create, params: { account_invitation: {
        name: FFaker::Name.first_name,
        email: FFaker::Internet.email,
        token: SecureRandom.urlsafe_base64(16)
      }, account_id: account.id }
    end

    before { sign_in user }

    it { is_expected.to redirect_to(account_invitations_path) }
    it { is_expected.to have_http_status(302) }
    it { expect { subject }.to change { AccountInvitation.where(user_id: user.id).count }.by(1) }
    it { expect { subject }.to change { AccountInvitation.count }.by(1) }
  end

  describe '#destroy' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    let!(:account_invitation) { create(:account_invitation, user: user, account: account) }

    subject { delete :destroy, params: { account_id: account.id, id: account_invitation } }
    before { sign_in user }
    it { expect { subject }.to change { AccountInvitation.count }.from(1).to(0) }
  end

  describe '#accept_invitation' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    let!(:account_invitation) { create(:account_invitation, user: user, account: account) }

    subject do
      get :accept_invitation, params: { invitation_id: account_invitation.id, token: account_invitation.token }
    end

    before { sign_in user }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:accept_invitation) }
  end

  describe '#accept' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    let!(:account_invitation) { create(:account_invitation, user: user, account: account) }

    subject do
      post :accept, params: { invitation_id: account_invitation.id, token: account_invitation.token }
    end

    before { sign_in user }

    it { expect(account_invitation.token).not_to be_nil }
    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to(account_path(account_invitation.account_id)) }
  end
end
