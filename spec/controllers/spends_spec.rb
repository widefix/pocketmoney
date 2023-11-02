require 'rails_helper'

RSpec.describe SpendsController, type: :controller do
  describe '#new' do
    let(:account) { create(:account, :parent) }

    subject(:new) { get :new, params: { account_id: account } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#create' do
    let(:user) { create(:user, account: account) }
    let(:account) { create(:account, :with_notify)}
    let(:child) { create(:account, :with_notify, parent: user.account ) }
    let(:created_transaction) { Transaction.find_by(from_account: child)}
    let(:amount) { FFaker::Number.number }
    let(:description) { FFaker::Lorem.phrase }

    subject { post :create, params: { account_id: child, amount: amount, description: description } }

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

    it { is_expected.to redirect_to(account_path(child)) }
    it { is_expected.to have_http_status(:redirect)}
    it { expect { subject }.to change { Transaction.count }.by(1) }
    it { expect { subject }.to change { Transaction.count }.by(1) }

    def find_mail_to(email)
      ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email)}
    end
  end
end