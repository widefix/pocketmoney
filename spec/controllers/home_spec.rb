require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end
end