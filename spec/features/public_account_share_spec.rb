# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'PublicAccountShare', type: :feature do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }
  let(:child) { create(:account, :children, parent: account) }
  let!(:account_share) { create(:account_share, user: user, account: account) }
  let!(:objective) { create(:objective, account: account) }
  let!(:transaction) { create(:transaction, to_account: child, from_account: account) }
  let!(:automatic_topup_config) { create(:account_automatic_topup_config, from_account: account, to_account: account) }

  scenario 'User views the show page' do
    visit public_account_path(token: account_share.token)

    expect(page).to have_http_status(:success)
    expect(page).to have_content(account.name)
    expect(page).to have_content(account.balance)
    expect(page).to have_link('Back', href: my_account_path)
    expect(page).to have_selector('.transactions table.table tbody tr', count: 1)
    expect(page).to have_selector('.objectives table.table tbody tr', count: 1)
    expect(page).to have_selector('.automatic-topup-configs table.table tbody tr', count: 1)
  end
end
