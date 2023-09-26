desc 'Top up accounts automatically'
task top_up_accounts: :environment do
  if Date.current.friday?
    AccountAutomaticTopupConfig.visible.find_each do |config|
      AutomaticTopupAction.new(
        from: config.from_account,
        to: config.to_account,
        amount: config.amount
      ).perform
    end
  end
end
