desc 'Top up accounts automatically'
task :update_feed => :environment do
  Transaction.create!(from_account: 'andrei', to_account: 'vitya', amount: 25)
end
