# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendNotification, type: :service do
  let!(:parent) { create(:account, :parent) }
  let!(:user) { create(:user, account: parent) }
  let!(:account) { create(:account, :children, parent: parent) }
  let!(:second_account) { create(:account, :parent) }
  let!(:second_user) { create(:user, account: second_account) }

  describe '#execute' do
    subject(:execute) { described_class.call(account) }

    before do
      create(:account_share, user: user, account: account, email: second_user.email, accepted_at: Time.current)
      create(:transaction, to_account: account, from_account: parent)
    end

    context 'when parents to recieve notifications' do
      it { expect { subject }.to send_email(to: [second_user.email, user.email]) }
    end

    context 'when kid to recieve notifications' do
      before do
        account.update_attribute(:notice_parents, false)
        account.update_attribute(:notification, true)
      end

      it { expect { subject }.to send_email(to: [account.email]) }
    end

    context 'when kid and parents to recieve notifications' do
      before do
        account.update_attribute(:notification, true)
      end

      it { expect { subject }.to send_email(to: [account.email, second_user.email, user.email]) }
    end

    context 'when not to recieve notifications' do
      before do
        account.update_attribute(:notice_parents, false)
      end

      it { expect { subject }.not_to send_email }
    end
  end

  describe '#recipients' do
    subject(:recipients) { described_class.new(account).send(:recipients) }

    before do
      create(:account_share, user: user, account: account, email: second_user.email, accepted_at: Time.current)
    end

    context 'when parents to recieve notifications' do
      it { is_expected.to match([second_user.email, user.email]) }
    end

    context 'when kid to recieve notifications' do
      before do
        account.update_attribute(:notice_parents, false)
        account.update_attribute(:notification, true)
      end

      it { is_expected.to match([account.email]) }
    end

    context 'when kid and parents to recieve notifications' do
      before do
        account.update_attribute(:notification, true)
      end

      it { is_expected.to match([account.email, second_user.email, user.email]) }
    end

    context 'when not to recieve notifications' do
      before do
        account.update_attribute(:notice_parents, false)
      end

      it { is_expected.to be_empty }
    end
  end

  describe '#parent_emails' do
    subject(:parent_emails) { described_class.new(account).send(:parent_emails) }

    context 'when account is shared' do
      before do
        create(:account_share, user: user, account: account, email: second_user.email, accepted_at: Time.current)
      end

      it { is_expected.to match([second_user.email, user.email]) }
    end

    context 'when account is not shared' do
      it { is_expected.to match([user.email]) }
    end
  end
end
