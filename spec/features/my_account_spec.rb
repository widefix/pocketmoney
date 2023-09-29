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
    accounts_block = find('.card.box.accounts')
    expect(accounts_block).to have_content(child.name)
    expect(accounts_block).to have_content('Balance')
    expect(accounts_block).to have_content(child.balance)
    expect(accounts_block).to have_link(nil, href: new_account_topup_path(child))
    expect(accounts_block).to have_link(nil, href: new_account_spend_path(child))

    expect(page).to have_content('Shared accounts')

    shared_accounts_block = find('.card.box.shared-accounts')
    expect(shared_accounts_block).to have_content(accepted_share.account.name)
    expect(shared_accounts_block).to have_content('Balance')
    expect(shared_accounts_block).to have_content(accepted_share.account.balance)
    expect(shared_accounts_block).to have_link(nil, href: new_account_topup_path(accepted_share.account))
    expect(shared_accounts_block).to have_link(nil, href: new_account_spend_path(accepted_share.account))

    expect(page).to have_content('Unaccepted shares')

    unaccepted_shares_block = find('.columns.unaccepted-shares')
    expect(unaccepted_shares_block).to have_selector('table.table tbody tr', count: 1)
    expect(unaccepted_shares_block).to have_content(unaccepted_share.account.name)
    expect(unaccepted_shares_block).to have_content(unaccepted_share.account.parent.email)
    expect(unaccepted_shares_block).to have_content(unaccepted_share.created_at.to_formatted_s(:short))
    expect(unaccepted_shares_block).to have_link('accept', href: accept_account_share_url(token: unaccepted_share.token))
  end
end
