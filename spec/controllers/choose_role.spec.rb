# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChooseRoleController, type: :controller do
  describe '#index' do
    subject(:index) { get :index }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:index) }
  end
end
