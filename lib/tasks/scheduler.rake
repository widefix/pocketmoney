desc 'Top up accounts automatically'
task top_up_accounts: :environment do
  Transaction.create!(from_account: 'andrei', to_account: 'vitya', amount: 25)
end
