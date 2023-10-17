# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObjectiveNotificationService, type: :service do
  let!(:parent) { create(:account, :parent) }
  let!(:user) { create(:user, account: parent) }
  let!(:account) { create(:account, :children, parent: parent) }
  let!(:config) { create(:account_automatic_topup_config, params) }
  let!(:objective) { create(:objective, account: account, amount: amount) }
  let(:params) { { from_account: parent, to_account: account, amount: 10 } }
  let(:amount) { 10 }

  describe '#perform' do
    subject(:service) { described_class.new.perform }

    context 'when goal is almost achieved' do
      it { expect { subject }.to change { objective.reload.goal_almost_achieved_notified }.to(true) }
    end

    context 'when goals are not almost achieved' do
      let(:amount) { 20 }
      it { expect { subject }.not_to(change { objective.reload.goal_almost_achieved_notified }) }
    end

    context 'when goal is achieved' do
      before { create(:transaction, to_account: account, from_account: parent, amount: 10) }

      it { expect { subject }.to change { objective.reload.goal_achieved_notified }.to(true) }
    end

    context 'when goals are not achieved' do
      it { expect { subject }.not_to(change { objective.reload.goal_achieved_notified }) }
    end
  end

  describe '#check_almost_achieved' do
    subject(:service) { described_class.new }

    context 'when the goal is almost achieved' do
      it do
        expect { subject.send(:check_almost_achieved, objective, 1) }
          .to change { objective.reload.goal_almost_achieved_notified }.to(true)
      end
    end

    context 'when the goal is not almost achieved' do
      it do
        expect { subject.send(:check_almost_achieved, objective, 2) }
          .not_to(change { objective.reload.goal_almost_achieved_notified })
      end
    end

    context 'when already notified' do
      before { objective.update_attribute(:goal_almost_achieved_notified, true) }
      it do
        expect { subject.send(:check_almost_achieved, objective, 1) }
          .not_to(change { objective.reload.goal_almost_achieved_notified })
      end
    end
  end

  describe '#check_achieved' do
    subject(:service) { described_class.new }

    context 'when the goal is achieved' do
      it do
        expect { subject.send(:check_achieved, objective, 10, 10) }
          .to change { objective.reload.goal_achieved_notified }.to(true)
      end
    end

    context 'when the goal is not achieved' do
      it do
        expect { subject.send(:check_achieved, objective, 9, 10) }
          .not_to(change { objective.reload.goal_achieved_notified })
      end
    end

    context 'when already notified' do
      before { objective.update_attribute(:goal_achieved_notified, true) }
      it do
        expect { subject.send(:check_achieved, objective, 10, 10) }
          .not_to(change { objective.reload.goal_achieved_notified })
      end
    end
  end
end
