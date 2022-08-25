require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    
    subject { get :index }

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:index) }
    it { is_expected.to_not render_template('accounts/new')}
  end
end