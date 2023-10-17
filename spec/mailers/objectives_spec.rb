# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObjectivesMailer, type: :mailer do
  let!(:parent) { create(:account, :parent) }
  let!(:user) { create(:user, account: parent) }
  let!(:account) { create(:account, :children, parent: parent) }
  let!(:objective) { create(:objective, account: account) }

  subject(:mail) { ObjectivesMailer.objectives_achieved(objective).deliver }

  describe 'objectives_achieved' do
    subject(:mail) { ObjectivesMailer.objectives_achieved(objective).deliver }

    it { expect(mail.to).to eq([user.email]) }
    it { expect(mail.subject).to eq('Objectives achieved') }
    it { expect(mail.body.encoded).to match(account.name) }
  end

  describe 'objectives_almost_achieved' do
    subject(:mail) { ObjectivesMailer.objectives_almost_achieved(objective).deliver }

    it { expect(mail.to).to eq([user.email]) }
    it { expect(mail.subject).to eq('Objectives almost achieved') }
    it { expect(mail.body.encoded).to match(account.name) }
  end
end
