# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObjectivesMailer, type: :mailer do
  let!(:parent) { create(:account, :parent) }
  let!(:user) { create(:user, account: parent) }
  let!(:account) { create(:account, :children, parent: parent) }
  let!(:objective) { create(:objective, account: account) }

  describe '#goal_achieved' do
    subject(:mail) { ObjectivesMailer.goal_achieved(objective, [user.email]).deliver }

    it { expect(mail.to).to eq([user.email]) }
    it { expect(mail.subject).to eq('Goal achieved') }
    it { expect(mail.body.encoded).to match(account.name) }
    it { expect { subject }.to send_email(to: user.email) }
  end

  describe '#goal_almost_achieved' do
    subject(:mail) { ObjectivesMailer.goal_almost_achieved(objective, [user.email]).deliver }

    it { expect(mail.to).to eq([user.email]) }
    it { expect(mail.subject).to eq('Goal almost achieved') }
    it { expect(mail.body.encoded).to match(account.name) }
    it { expect { subject }.to send_email(to: user.email) }
  end
end
