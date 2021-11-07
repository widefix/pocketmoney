desc 'Top up accounts automatically'
task top_up_accounts: :environment do
  if Date.current.friday?
    Transaction.create!(from_account: Account.find_by!(name: 'andrei'), to_account: Account.find_or_create_by!(name: 'vitya'), amount: 25)
  end
end
