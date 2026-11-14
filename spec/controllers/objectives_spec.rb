# frozen_string_literal: true

require "rails_helper"

RSpec.describe ObjectivesController, type: :controller do
  describe '#new' do
    let(:account) { create(:account, :parent) }

    subject(:new) { get :new, params: { account_id: account } }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:new) }    
    it { is_expected.to_not render_template('home/index') }
  end

  describe '#create' do
    render_views
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }

    before { sign_in user }

    subject { post :create, params: { name: name, amount: amount, account_id: account } }

    context 'when params is valid' do
      let(:amount) { FFaker::Number.number }
      let(:name) { FFaker::Book.title }

      it { is_expected.to have_http_status(302) }
      it { expect { subject }.to change { Objective.count }.by(1) }
    end

    context 'when params are blank' do
      let(:amount) { '' }
      let(:name) { '' }

      it { expect { subject }.not_to(change { Objective.count }) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { is_expected.to render_template(:new) }

      it 'shows validation errors' do
        subject
        expect(response.body).to include('Name can&#39;t be blank', 'Amount is not a number')
      end
    end

    context 'when the amount is not numeric' do
      let(:name) { '800' }
      let(:amount) { 'Helmet' }

      it { expect { subject }.not_to(change { Objective.count }) }
      it { is_expected.to have_http_status(:unprocessable_entity) }

      it 'preserves the input and explains the error' do
        subject
        expect(response.body).to include('Amount is not a number', 'value="800"', 'value="Helmet"')
        forms = Nokogiri::HTML(response.body).css("form[action='#{account_objectives_path(account)}']")
        expect(forms.size).to eq(1)
        expect(forms.first.at_css('button[type="submit"]')).to be_present
      end
    end
  end

  describe '#destroy' do
    let!(:account) { create(:account, :parent) }
    let!(:objective) { create(:objective, account: account) }

    subject(:destroy) { delete :destroy, params: { id: objective.id } }

    it { is_expected.to have_http_status(:redirect) }
    it { is_expected.to redirect_to(account_path(account, anchor: 'goals')) }
    it { expect { subject }.to change { Objective.count }.by(-1) }
  end

  describe '#accomplish' do
    let(:account) { create(:account, :parent) }
    let(:user) { create(:user, account: account) }
    let!(:objective) { create(:objective, account: account) }

    before { sign_in user }

    subject { patch :accomplish, params: { id: objective } }

    context 'when params is valid' do
      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(account_path(account, anchor: 'goals')) }
      it { expect { subject }.to change { objective.reload.accomplished_at }.from(nil) }
    end
  end
end
