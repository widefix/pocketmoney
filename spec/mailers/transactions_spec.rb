require "rails_helper"

RSpec.describe TransactionsMailer, type: :mailer do
  describe "notify" do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent: parent ) }
    let!(:transaction) { create(:transaction, to_account: child, from_account: parent) }

    subject(:mail) { TransactionsMailer.transaction_notification(child).deliver }

    it { expect(mail.to).to eq([child.email]) }
    it { expect(mail.subject).to eq("Transaction added.") }
    it { expect(mail.body.encoded).to match(child.name) }
  end
end
