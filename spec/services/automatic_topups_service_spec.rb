# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomaticTopupsService, type: :service do
  let(:account) { create(:account, :parent) }
  let!(:config) { create(:account_automatic_topup_config, from_account: account, to_account: account, amount: 10) }

  subject(:service) { described_class.new }

  describe '#perform' do
    context "when account isn't archived" do
      context 'when amount is positive' do
        it { expect { service.perform }.to change { Transaction.count }.by(1) }
      end

      context 'when amount is negative' do
        it do
          config.update_attribute(:amount, -10)
          expect { service.perform }.not_to(change { Transaction.count })
        end
      end

      context 'when amount is zero' do
        it do
          config.update_attribute(:amount, 0)
          expect { service.perform }.not_to(change { Transaction.count })
        end
      end

      context 'when a similar transaction already exists' do
        let!(:existing_transaction) do
          create(:transaction, from_account: account, to_account: account, amount: 10, description: 'Automatic Top-up')
        end

        it { expect { service.perform }.not_to(change { Transaction.count }) }
      end
    end

    context 'when account is archived' do
      let(:account) { create(:account, :parent, archived_at: Time.current) }

      it { expect { service.perform }.not_to(change { Transaction.count }) }
    end
  end
end
