# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Choose Role Page', type: :feature do
  scenario 'User sees options to choose role' do
    visit choose_role_path

    expect(page).to have_content('Choose your role')
    expect(page).to have_content('If you manage your kid account')
    expect(page).to have_link('Parent')
    expect(page).to have_content('If you have a parental code to manage an account')
    expect(page).to have_link('Kid')
    expect(page).to have_content('Help your kid to manage their budget. Give them a parental code to manage their account.')
    expect(page).to have_css('.image.is-coins')
  end

  scenario 'User can navigate to Parent role' do
    visit choose_role_path

    click_link 'Parent'

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'User can navigate to Kid role' do
    visit choose_role_path

    click_link 'Kid'

    expect(current_path).to eq(new_sign_in_kid_path)
  end
end
