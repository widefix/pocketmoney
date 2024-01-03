# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Edit Account Page', type: :feature do
  let(:parent_account) { create(:account, :parent) }
  let(:user) { create(:user, account: parent_account) }
  let(:account) { create(:account, :children, parent: parent_account) }

  before { sign_in user }

  scenario 'User edits the account' do
    visit edit_account_path(account)

    expect(page).to have_content('Edit account')
    expect(page).to have_content('Change Avatar')
    expect(page).to have_content('Change Background')
    expect(page).to have_content('Report transactions')
    expect(page).to have_content('Report transactions to parents')
    expect(page).to have_link('Archive Account')
    expect(page).to have_link('Back')
    expect(page).to have_button('Save')
  end
end
