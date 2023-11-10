require "rails_helper"

RSpec.describe TopupsController, type: :controller do
  describe '#create' do
    let(:user) { create(:user, account: account) }
    let(:account) { create(:account, :with_notify)}
    let(:child) { create(:account, :with_notify, parent: user.account ) }
    let(:created_transaction) { Transaction.find_by(to_account: child)}
    let(:amount) { FFaker::Number.number }
    let(:description) { FFaker::Lorem.phrase }

    subject do
      request.env['HTTP_REFERER'] = 'https://budgetingkid.com/my_account'
      post :create, params: { account_id: child, amount: amount, description: description }
    end

    before { sign_in user }

    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }

    it 'recipient must be correct' do
      subject
      expect(find_mail_to(child.email).to).to eq([child.email, user.email])
    end

    it 'subject must be correct' do
      subject
      expect(find_mail_to(child.email).subject).to eq("Transaction added.")
    end

    it 'originator must be correct' do
      subject
      expect(created_transaction.originator).to eq(user)
    end

    it 'access token not be nil' do
      subject
      expect(created_transaction.access_token).not_to be_nil
    end

    it 'refreshes the current page' do
      subject
      is_expected.to redirect_to('https://budgetingkid.com/my_account')
    end
    it { is_expected.to have_http_status(:redirect)}
    it { expect { subject }.to change { Transaction.count }.by(1) }
    it { expect { subject }.to change { Transaction.count }.by(1) }

    def find_mail_to(email)
      ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email)}
    end
  end
end