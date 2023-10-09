# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'top_up_accounts task' do
  let(:account) { create(:account, :parent) }
  let!(:config) { create(:account_automatic_topup_config, from_account: account, to_account: account, amount: 100) }

  before do
    BudgetingKid::Application.load_tasks
    Rake::Task.define_task(:environment)
  end

  it { expect { Rake::Task['top_up_accounts'].invoke }.not_to raise_exception }
end
