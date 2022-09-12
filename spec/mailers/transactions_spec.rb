require "rails_helper"

RSpec.describe TransactionsMailer, type: :mailer do
  describe "notify" do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent: parent ) }
    let!(:transaction) { create(:transaction, to_account: child, from_account: parent) }

    subject(:mail) { TransactionsMailer.transaction_notification(child).deliver }

    it 'recipient must be correct' do
      expect(mail).to eq(ActionMailer::Base.deliveries.find { |mail| mail.to.include?(child.email) })
    end
    
    it { expect { mail }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    it { expect(mail.to).to eq([child.email]) }
    it { expect(mail.from).to eq(["no-reply@widefix.com"]) }
    it { expect(mail.subject).to eq("Transaction added.") }
    it { expect(mail.body.encoded).to match(child.name) }

  end
end