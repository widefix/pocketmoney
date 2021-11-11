desc 'Top up accounts automatically'
task top_up_accounts: :environment do
  if Date.current.friday?
    AccountAutomaticTopupConfig.find_each do |config|
      Transaction.create!(
        from_account: config.from_account,
        to_account: config.to_account,
        amount: config.amount
      )
    end
  end
end
