# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomaticTopupsService, type: :service do
  let(:account) { create(:account, :parent) }
  let!(:first_config) do
    create(:account_automatic_topup_config, params)
  end
  let!(:second_config) do
    create(:account_automatic_topup_config, params)
  end
  let!(:thirst_config) do
    create(:account_automatic_topup_config, params)
  end
  let(:params) { { from_account: account, to_account: account, amount: 10 } }

  subject(:service) { described_class.new }

  describe '#perform' do
    context "when account isn't archived" do
      before { second_config.update_attribute(:amount, -10) }

      it { expect { service.perform }.to change { Transaction.count }.by(2) }
    end

    context 'when account is archived' do
      let(:account) { create(:account, :parent, archived_at: Time.current) }

      it { expect { service.perform }.not_to(change { Transaction.count }) }
    end
  end
end
