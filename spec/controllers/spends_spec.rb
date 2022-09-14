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
    let(:account) { create(:account, :with_notify) }
    let(:user) { create(:user, account: account) }
    let(:amount) { FFaker::Number.number }
    let(:description) { FFaker::Lorem.phrase }
    let!(:notify_true) do
      user.account.notification = true
      user.account.email = user.email
      user.account.save
    end   

    subject { post :create, params: { account_id: user.account, amount: amount, description: description } }

    before { sign_in user }

    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }

    it 'recipient must be correct' do
      subject
      expect(find_mail_to(user.account.email).to).to eq([user.account.email])
    end

    it { is_expected.to redirect_to(account_path(user.account)) }
    it { is_expected.to have_http_status(:redirect)}
    it { expect { subject }.to change { Transaction.count }.by(1) }
    it { expect { subject }.to change { Transaction.count }.by(1) }

    def find_mail_to(email)
      ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email)}
    end
  end
end