# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Sign in for kid page', type: :feature do
  scenario 'Kid logs in with parental key' do
    visit new_sign_in_kid_path

    expect(page).to have_content('Login for kid')
    expect(page).to have_content('Enter Parental Key')

    expect(page).to have_field('Parental Key', type: 'text')
  end

  scenario 'Kid navigates to parent login page' do
    visit new_sign_in_kid_path

    expect(page).to have_content("Don't have a parental core or a parent?")
    expect(page).to have_link('Log in as a parent')

    click_link 'Log in as a parent'
    expect(current_path).to eq(new_user_session_path)
  end
end
