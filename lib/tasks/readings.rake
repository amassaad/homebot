namespace :readings do

  desc "emit hydro usage from 24 hours ago"
  task emit: :environment do
    next unless @reading = Reading.where(time: (Time.now - 48.hours)..(Time.now - 47.hours)).first
    StatsD.gauge('york.hourly.cost', @reading.cost)
    StatsD.gauge('york.hourly.amount', @reading.amount)
    StatsD.gauge('york.datalag', (Time.now - Reading.last.time) / 3600)
    sleep(25)
  end

  desc "Import readings to the db from an excel file of hourly readings located in the applicaiton root"
  task import_from_file: :environment do
    Reading.import
  end

  desc "save locally"
  task save_file: :environment do
    Reading.save
  end
end
