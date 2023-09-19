# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbacksController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#new' do
    subject(:new) { get :new }
    it { is_expected.to render_template(:new) }
  end

  describe '#create' do
    subject do
      post :create, params: { description: FFaker::Lorem.sentence[0, 500] }
    end

    it { is_expected.to render_template(:notification) }
    it { is_expected.to have_http_status(200) }
    it { expect { subject }.to change { Feedback.where(user_id: user.id).count }.by(1) }
    it { expect { subject }.to change { Feedback.count }.by(1) }
  end
end
