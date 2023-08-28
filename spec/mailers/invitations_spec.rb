# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationMailer, type: :mailer do
  describe 'account invitation' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let(:invitee_user) { create(:user) }
    let!(:account_invitation) { create(:account_invitation, user: user, account: account, email: invitee_user.email) }

    subject(:mail) { InvitationMailer.account_invitation(account_invitation).deliver }

    it { expect(mail.to).to eq([invitee_user.email]) }
    it { expect(mail.subject).to eq('Invitation to manage an account!') }
    it { expect(mail.body.encoded).to match(account_invitation.name) }
  end
end
