desc 'Top up accounts automatically'
task top_up_accounts: :environment do
  AutomaticTopupsService.new.perform if Date.current.friday?
end

desc 'Check and send notifications for achieved objectives'
task check_objectives: :environment do
  ObjectiveNotificationService.new.perform
end
