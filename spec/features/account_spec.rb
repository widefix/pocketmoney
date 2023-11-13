# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Account', type: :feature do
  let(:parent_account) { create(:account, :parent) }
  let(:user) { create(:user, account: parent_account) }
  let(:account) { create(:account, :children, parent: parent_account) }
  let!(:objective) { create(:objective, account: account) }
  let!(:transaction) { create(:transaction, to_account: account, from_account: parent_account) }
  let!(:automatic_topup_config) { create(:account_automatic_topup_config, from_account: parent_account, to_account: account) }

  before { sign_in user }

  scenario 'User views the account page' do
    visit account_path(account)

    expect(page).to have_http_status(:success)
    expect(page).to have_link('Edit Account', href: edit_account_path(account))
    expect(page).to have_link('Share Account', href: account_shares_path(account))
    expect(page).to have_link('Archive Account', href: archive_account_path(account))
      .or(have_link('Terminate Account', href: terminate_shared_account_path(account)))
    expect(page).to have_content(account.name)
    expect(page).to have_content(account.balance)
    expect(page).to have_button('Increase')
    expect(page).to have_button('Decrease')

    transactions_block = find('.column.transactions')
    expect(transactions_block).to have_content('Transaction History')
    expect(transactions_block).to have_selector('table.table tbody tr', count: 2)
    expect(transactions_block).to have_text(transaction.date)
    expect(transactions_block).to have_text(transaction.signed_amount(account))
    expect(transactions_block).to have_text(transaction.description)
    expect(transactions_block).to have_link(href: transaction_path(transaction))

    objectives_block = find('.column.goals')
    expect(objectives_block).to have_selector('table.table tbody tr', count: 2)
    expect(objectives_block).to have_text(objective.name)
    expect(objectives_block).to have_text(objective.amount)
    expect(objectives_block).to have_link('Delete', href: objective_path(objective))
    expect(objectives_block).to have_link('Add Goal', href: new_account_objective_path(account))

    automatic_topup_config_block = find('.columns.automatic-topup-configs')
    expect(automatic_topup_config_block).to have_text(automatic_topup_config.amount)
    expect(automatic_topup_config_block)
      .to have_link('Edit', href: edit_account_account_automatic_topup_config_path(account, automatic_topup_config))
    expect(automatic_topup_config_block)
      .to have_link('Delete', href: account_account_automatic_topup_config_path(account, automatic_topup_config))
    expect(automatic_topup_config_block)
      .not_to have_link('Add amount', href: new_account_account_automatic_topup_config_path(account))
  end

  scenario 'User views the account page without automatic_topup_config' do
    automatic_topup_config.destroy
    visit account_path(account)

    automatic_topup_config_block = find('.columns.automatic-topup-configs')
    expect(automatic_topup_config_block)
      .to have_link('Add', href: new_account_account_automatic_topup_config_path(account))
  end
end
