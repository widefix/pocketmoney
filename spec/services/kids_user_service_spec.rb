# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KidsUserService, type: :service do
  let!(:parent_account) { create(:account, :parent) }
  let!(:account) { create(:account, :children, parent_id: parent_account.id) }
  let!(:parent_user) { create(:user, account: parent_account) }
  let!(:account_share) { create(:account_share, user: parent_user, account: account, parental_key: parental_key) }
  let(:parental_key) { SecureRandom.hex(3).upcase }

  subject(:service) { described_class.new(account_share).perform }

  describe '#perform' do
    context 'when the user does not exist' do
      it { expect { subject }.to change { User.count }.by(1) }
      it { expect { subject }.to change { Account.count }.by(1) }
      it { is_expected.to be_an_instance_of(User) }
    end

    context 'when the user does exist' do
      let!(:kids_account) { create(:account, :parent) }
      let!(:kids_user) { create(:user, account: kids_account, parental_key: parental_key, email: account.email) }

      it { expect { subject }.not_to(change { User.count }) }
      it { expect { subject }.not_to(change { Account.count }) }
      it { is_expected.to be_an_instance_of(User) }
    end
  end
end
