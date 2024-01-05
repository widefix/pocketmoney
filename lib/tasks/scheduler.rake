desc 'Top up accounts automatically'
task top_up_accounts: :environment do
  AutomaticTopupsService.new.perform if Date.current.friday?
end
