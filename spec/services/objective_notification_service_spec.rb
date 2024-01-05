# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObjectiveNotificationService, type: :service do
  let!(:parent) { create(:account, :parent) }
  let!(:user) { create(:user, account: parent) }
  let!(:account) { create(:account, :children, parent: parent) }
  let!(:second_account) { create(:account, :parent) }
  let!(:second_user) { create(:user, account: second_account) }
  let!(:config) { create(:account_automatic_topup_config, params) }
  let!(:objective) { create(:objective, account: account, amount: amount) }
  let(:params) { { from_account: parent, to_account: account, amount: 10 } }
  let(:amount) { 10 }

  subject(:service) { described_class.new(account).perform }

  describe '#perform' do
    context 'when goal is achieved' do
      before { create(:transaction, to_account: account, from_account: parent, amount: amount) }

      it { expect { subject }.to send_email(to: user.email) }
      it { expect { subject }.not_to(change { objective.reload.goal_almost_achieved_notified_at }) }
      it { expect { subject }.to change { objective.reload.goal_achieved_notified_at }.from(nil).to(be_a(Time)) }
    end

    context 'when goal is almost achieved' do
      before do
        create(:account_share, user: user, account: account, email: second_user.email, accepted_at: Time.current)
      end

      it { expect { subject }.to send_email(to: [second_user.email, user.email]) }
      it { expect { subject }.not_to(change { objective.reload.goal_achieved_notified_at }) }
      it { expect { subject }.to change { objective.reload.goal_almost_achieved_notified_at }.from(nil).to(be_a(Time)) }
    end

    context 'when goal is achieved and account shared' do
      before do
        create(:transaction, to_account: account, from_account: parent, amount: amount)
        create(:account_share, user: user, account: account, email: second_user.email, accepted_at: Time.current)
      end

      it { expect { subject }.to send_email(to: [second_user.email, user.email]) }
      it { expect { subject }.not_to(change { objective.reload.goal_almost_achieved_notified_at }) }
      it { expect { subject }.to change { objective.reload.goal_achieved_notified_at }.from(nil).to(be_a(Time)) }
    end

    context 'when account archived' do
      before do
        account.update_attribute(:archived_at, Time.current)
        create(:transaction, to_account: account, from_account: parent, amount: amount)
        create(:account_share, user: user, account: account, email: second_user.email, accepted_at: Time.current)
      end

      it { expect { subject }.not_to send_email(to: user.email) }
      it { expect { subject }.not_to send_email(to: second_user.email) }
      it { expect { subject }.not_to(change { objective.reload.goal_almost_achieved_notified_at }) }
      it { expect { subject }.not_to(change { objective.reload.goal_achieved_notified_at }) }
    end

    context 'when automatic topup configs is empty but goal is achieved' do
      before do
        config.destroy
        create(:transaction, to_account: account, from_account: parent, amount: amount)
      end

      it { expect { subject }.to send_email(to: user.email) }
      it { expect { subject }.not_to(change { objective.reload.goal_almost_achieved_notified_at }) }
      it { expect { subject }.to change { objective.reload.goal_achieved_notified_at }.from(nil).to(be_a(Time)) }
    end

    context 'when goals are not almost achieved' do
      let(:amount) { 20 }

      it { expect { subject }.not_to send_email(to: user.email) }
      it { expect { subject }.not_to(change { objective.reload.goal_almost_achieved_notified_at }) }
      it { expect { subject }.not_to(change { objective.reload.goal_achieved_notified_at }) }
    end
  end
end
