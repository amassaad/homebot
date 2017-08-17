namespace :fetch_climate do
  desc "Fetch Climate Conditions"

  SLEEP = 60

  task :now => :environment do
    Climate.get_conditions
    puts "done, waiting #{SLEEP} seconds to attempt StatsD Flush"
    sleep(SLEEP)
  end
end
