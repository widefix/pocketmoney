class HomeController < ApplicationController
  def index
    @pocket_money_reasons = YAML.load_file(Rails.root.join('config', 'pocket_money_reasons.yml'))['reasons']
  end
end
