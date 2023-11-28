# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateAccountService, type: :service do
  let!(:parent_account) { create(:account, :parent) }
  let!(:account) { create(:account, :children, parent_id: parent_account.id) }
  let!(:parent_user) { create(:user, account: parent_account) }
  let(:params) { { email: FFaker::Internet.email, name: FFaker::Name.first_name } }

  subject(:service) { described_class.new(account, params).perform }

  describe '#perform' do
    context 'when the account share does not exist' do
      it { expect { subject }.to change { account.reload.name }.to(params[:name]) }
      it { expect { subject }.to change { account.reload.email }.to(params[:email]) }
      it { is_expected.to eq true }
    end

    context 'with notification and empty email' do
      let(:params) { { notification: true, email: '' } }

      it { expect(subject).to eq false }
    end

    context 'when the account share does exist' do
      let(:parental_key) { SecureRandom.hex(3) }
      let!(:account_share) { create(:account_share, user: parent_user, account: account, parental_key: parental_key) }

      context 'when the user does not exist' do
        it { expect { subject }.to change { account.reload.name }.to(params[:name]) }
        it { expect { subject }.to change { account.reload.email }.to(params[:email]) }
        it { expect { subject }.to change { account_share.reload.name }.to(params[:name]) }
        it { expect { subject }.to change { account_share.reload.email }.to(params[:email]) }
        it { is_expected.to eq true }
      end

      context 'when the user does exist' do
        let!(:kids_account) { create(:account, :parent) }
        let!(:kids_user) { create(:user, account: kids_account, parental_key: parental_key, email: account.email) }

        context 'when email not used' do
          it { expect { subject }.to change { account.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { account.reload.email }.to(params[:email]) }
          it { expect { subject }.to change { account_share.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { account_share.reload.email }.to(params[:email]) }
          it { expect { subject }.to change { kids_user.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { kids_user.reload.email }.to(params[:email]) }
          it { expect { subject }.to change { kids_account.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { kids_account.reload.email }.to(params[:email]) }
          it { is_expected.to eq true }
        end

        context 'when email already used' do
          let!(:user) { create(:user, email: params[:email]) }

          it { is_expected.to eq false }
        end

        context 'when email already used but it is kid' do
          let!(:kids_user) { create(:user, account: kids_account, parental_key: parental_key, email: params[:email]) }

          it { expect { subject }.to change { account.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { account.reload.email }.to(params[:email]) }
          it { expect { subject }.to change { account_share.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { account_share.reload.email }.to(params[:email]) }
          it { expect { subject }.to change { kids_user.reload.name }.to(params[:name]) }
          it { expect { subject }.not_to(change { kids_user.reload.email }) }
          it { expect { subject }.to change { kids_account.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { kids_account.reload.email }.to(params[:email]) }
          it { is_expected.to eq true }
        end

        context 'when email is empty' do
          let(:params) { { email: '', name: FFaker::Name.first_name } }

          it { expect { subject }.to change { account.reload.name }.to(params[:name]) }
          it { expect { subject }.to change { account.reload.email }.to(params[:email]) }
          it { expect { subject }.to change { account_share.reload.name }.to(params[:name]) }
          it { expect { subject }.not_to(change { account_share.reload.email }) }
          it { expect { subject }.to change { kids_user.reload.name }.to(params[:name]) }
          it { expect { subject }.not_to(change { kids_user.reload.email }) }
          it { expect { subject }.to change { kids_account.reload.name }.to(params[:name]) }
          it { expect { subject }.not_to(change { kids_account.reload.email }) }
          it { is_expected.to eq true }
        end

        context 'when email is nil' do
          let(:params) { { email: nil, name: FFaker::Name.first_name } }

          it { is_expected.to eq false }
        end

        context 'when name is empty' do
          let(:params) { { email: FFaker::Internet.email, name: '' } }

          it { is_expected.to eq false }
        end

        context 'when name is nil' do
          let(:params) { { email: FFaker::Internet.email, name: nil } }

          it { is_expected.to eq false }
        end
      end
    end
  end
end
