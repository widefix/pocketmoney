require "rails_helper"

RSpec.describe TransactionsMailer, :type => :mailer do
  describe "notify" do
    let(:parent) { create(:account, :parent) }
    let(:child) { create(:account, :children, parent_id: parent.id ) }
    let!(:transaction) { create(:transaction, to_account_id: child.id, from_account_id: parent.id) }

    subject { TransactionsMailer.transaction_notification(child).deliver }

    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    it { expect(subject.to).to eq([child.email]) }
    it { expect(subject.from).to eq(["no-reply@widefix.com"]) }
    it { expect(subject.subject).to eq("Transaction added.") }
    it { expect(subject.body.encoded).to match(child.name) }
  end
end