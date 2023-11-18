# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'PublicAccountShare', type: :feature do
  let(:parent_account) { create(:account, :parent) }
  let(:user) { create(:user, account: parent_account) }
  let(:account) { create(:account, :children, parent: parent_account) }
  let!(:account_share) { create(:account_share, user: user, account: account) }
  let!(:objective) { create(:objective, account: account) }
  let!(:transaction) { create(:transaction, to_account: account, from_account: parent_account) }
  let!(:automatic_topup_config) { create(:account_automatic_topup_config, from_account: parent_account, to_account: account) }

  scenario 'User views the public account page' do
    visit public_account_path(token: account_share.token)

    expect(page).to have_http_status(:success)
    expect(page).to have_content(account.name)
    expect(page).to have_content(account.balance)

    transactions_block = find('.column.transactions.box')
    expect(transactions_block).to have_selector('table.table tbody tr', count: 2)
    expect(transactions_block).to have_text(transaction.date)
    expect(transactions_block).to have_text(transaction.signed_amount(account))
    expect(transactions_block).to have_text(transaction.description)

    objectives_block = find('.column.goals.box')
    expect(objectives_block).to have_selector('table.table tbody tr', count: 2)
    expect(objectives_block).to have_text(objective.name)
    expect(objectives_block).to have_text(objective.amount)

    automatic_topup_config_block = find('.columns.automatic-topup-configs')
    expect(automatic_topup_config_block).to have_text(automatic_topup_config.amount)
  end
end
