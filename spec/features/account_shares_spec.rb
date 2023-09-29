# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'AccountShares', type: :feature do
  let(:account) { create(:account, :parent) }
  let(:user) { create(:user, account: account) }
  let!(:account_share) { create(:account_share, account: account, accepted_at: Time.current) }

  before { sign_in user }

  scenario 'User views the account shares page' do
    visit account_shares_path(account)

    expect(page).to have_http_status(:success)
    expect(page).to have_content('Account shares')
    expect(page).to have_content(account.name)
    expect(page).to have_content('Name')
    expect(page).to have_content('Email')
    expect(page).to have_content('Created')
    expect(page).to have_content('Accepted')
    expect(page).to have_content('Link')
    expect(page).to have_content('Actions')
    expect(page).to have_content(account_share.name)
    expect(page).to have_content(account_share.email)
    expect(page).to have_content(account_share.created_at.to_formatted_s(:short))
    expect(page).to have_content(account_share.accepted_at.to_formatted_s(:short))
    expect(page).to have_link('link', href: accept_account_share_url(token: account_share.token))
    expect(page).to have_link('Cancel', href: account_share_path(account, account_share))
  end
end
