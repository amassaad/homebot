# frozen_string_literal: true

namespace :volvo do
  desc "emit car odometer"
  task odometer: :environment do
    next unless @car = Volvo.first
    StatsD.gauge('car.volvo.odometer', @car.odometer)
    sleep(25)
  end

  desc "Import car data to database"
  task car: :environment do
    Volvo.car
  end

  desc "Update lease car milage data to database"
  task lease: :environment do
    Volvo.lease
    next unless @car = Volvo.first
    StatsD.gauge('car.volvo.lease_limit', @car.lease_limit * 54.79 * 1000)
    sleep(25)
  end
end
