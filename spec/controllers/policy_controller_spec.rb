# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PolicyController, type: :controller do
  describe '#show' do
    subject(:show) { get :show }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:show) }
    it { is_expected.to_not render_template('home/index') }
  end
end
