desc 'Top up accounts automatically'
task top_up_accounts: :environment do
  AutomaticTopupService.new.perform if Date.current.friday?
end
