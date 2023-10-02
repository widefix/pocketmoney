# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomaticTopupsService, type: :service do
  let(:account) { create(:account, :parent) }
  let!(:config) { create(:account_automatic_topup_config, from_account: account, to_account: account, amount: 100) }

  subject(:service) { described_class.new }

  describe '#perform' do
    context "when account isn't archived" do
      it { expect { service.perform }.to change { Transaction.count }.by(1) }
    end

    context 'when account is archived' do
      let(:account) { create(:account, :parent, archived_at: Time.current) }

      it { expect { service.perform }.not_to(change { Transaction.count }) }
    end
  end
end
