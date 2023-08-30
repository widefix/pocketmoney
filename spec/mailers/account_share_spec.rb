# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountShareMailer, type: :mailer do
  describe 'account share' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:shared_user) { create(:user) }
    let!(:account_share) { create(:account_share, user: user, account: account, email: shared_user.email) }

    subject(:mail) { AccountShareMailer.account_share(account_share).deliver }

    it { expect(mail.to).to eq([shared_user.email]) }
    it { expect(mail.subject).to eq('Share to manage an account!') }
    it { expect(mail.body.encoded).to match(account_share.name) }
  end
end
