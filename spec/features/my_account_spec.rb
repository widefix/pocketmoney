# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'MyAccount', type: :feature do
  let!(:account) { create(:account, :parent) }
  let!(:user) { create(:user, account: account) }
  let!(:child) { create(:account, :children, parent: account) }
  let!(:second_account) { create(:account, :parent) }
  let!(:second_user) { create(:user, account: second_account) }
  let!(:second_child) { create(:account, :children, parent: second_account) }
  let!(:accepted_share) do
    create(:account_share, user: second_user, account: second_child, email: user.email, accepted_at: Time.current)
  end
  let!(:unaccepted_share) { create(:account_share, user: second_user, account: second_child, email: user.email) }

  before { sign_in user }

  scenario 'User views the my account page' do
    visit my_account_path

    expect(page).to have_http_status(:success)
    expect(page).to have_button('Add account')
    expect(page).to have_content('Hi, Welcome back')

    accounts_block = find('.card.box.accounts')
    expect(accounts_block).to have_link(href: account_path(child))
    expect(accounts_block).to have_content(child.name)
    expect(accounts_block).to have_content("Balance: #{child.balance}", normalize_ws: true)
    expect(accounts_block).to have_button(count: 3)
    expect(accounts_block).to have_button('Increase')
    expect(accounts_block).to have_button('Decrease')

    expect(page).to have_content('Shared accounts')

    shared_accounts_block = find('.card.box.shared-accounts')
    expect(shared_accounts_block).to have_content("Account owner: #{accepted_share.account.parent.email}")
    expect(shared_accounts_block).to have_link(href: account_path(accepted_share.account))
    expect(shared_accounts_block).to have_content("Balance: #{accepted_share.account.balance}", normalize_ws: true)
    expect(shared_accounts_block).to have_button(count: 3)
    expect(shared_accounts_block).to have_button('Increase')
    expect(shared_accounts_block).to have_button('Decrease')

    expect(page).to have_content('Unaccepted shares')

    unaccepted_shares_block = find('.card.box.unaccepted_shares')
    expect(unaccepted_shares_block).to have_content(unaccepted_share.name)
    expect(unaccepted_shares_block).to have_content(unaccepted_share.account.parent.email)
    expect(unaccepted_shares_block).to have_button('Accept')
  end
end
