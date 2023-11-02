require "rails_helper"

RSpec.describe TransactionsMailer, type: :mailer do
  let!(:parent) { create(:account, :parent) }
  let!(:child) { create(:account, :children, parent: parent ) }
  let!(:transaction) { create(:transaction, to_account: child, from_account: parent) }

  describe "#automatic_top_up_done" do
    let!(:user) { create(:user, account: parent) }

    subject(:mail) { TransactionsMailer.automatic_top_up_done(transaction).deliver }

    it { expect(mail.to).to eq([user.email]) }
    it { expect(mail.subject).to eq("Automatic top up done") }
    it { expect(mail.body.encoded).to match(child.name) }
  end

  describe "#transaction_notification" do
    subject(:mail) { TransactionsMailer.transaction_notification(child, recipients).deliver }

    context 'when recipient exist' do
      let(:recipients) { [child.email] }

      it { expect(mail.to).to eq([child.email]) }
      it { expect(mail.subject).to eq("Transaction added.") }
      it { expect(mail.body.encoded).to match(child.name) }
    end

    context 'when recipient not exist' do
      let(:recipients) { [] }

      it { expect { subject }.not_to send_email(to: child.email) }
    end
  end
end
