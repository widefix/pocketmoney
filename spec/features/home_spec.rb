# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Home Page', type: :feature do
  scenario 'User visits the home page' do
    visit root_path

    sections_data = YAML.load_file(Rails.root.join('config', 'pocket_money_reasons.yml'))['reasons']

    sections_data.each do |section|
      expect(page).to have_content(section['name'])
      expect(page).to have_content(section['explanation'])
      expect(page).to have_css("img[alt*=\"#{section['name']}\"]")
    end

    go_buttons = page.all(:link, 'Go!')
    expect(go_buttons.size).to eq(9)
    go_buttons.each { |go_button| expect(go_button[:class]).to include('button') }
  end
end
