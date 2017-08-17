class Climate < ApplicationRecord
  require 'date'
  require 'net/https'
  require 'json'

  def self.get_conditions
    forecast_api_key = ENV['FORECAST_API_KEY']
    forecast_location_lat = ENV['LATITUDE']
    forecast_location_long = ENV['LONGITUDE']
    forecast_units = "ca"

    http = Net::HTTP.new("api.forecast.io", 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    StatsD.measure('GetConditions.performance') do
      response = http.request(Net::HTTP::Get.new("/forecast/#{forecast_api_key}/#{forecast_location_lat},#{forecast_location_long}?units=#{forecast_units}"))
      forecast = JSON.parse(response.body)

      currently = forecast["currently"]

      # currently

      # {
      #   "time"=>1475095320,
      #   "summary"=>"Clear",
      #   "icon"=>"clear-day",
      #   "nearestStormDistance"=>93,
      #   "nearestStormBearing"=>142,
      #   "precipIntensity"=>0,
      #   "precipProbability"=>0,
      #   "temperature"=>21.19,
      #   "apparentTemperature"=>21.19,
      #   "dewPoint"=>14.05,
      #   "humidity"=>0.64,
      #   "windSpeed"=>13.44,
      #   "windBearing"=>69,
      #   "visibility"=>16.09,
      #   "cloudCover"=>0.17,
      #   "pressure"=>1023.35,
      #   "ozone"=>318.71
      # }
      StatsD.gauge('york.climate.precipIntensity', currently["precipIntensity"].to_f )

      StatsD.gauge('york.climate.precipProbability', currently["precipProbability"].to_f )

      humidity = (currently["humidity"] * 100)
      StatsD.gauge('york.climate.apparentTemperature', currently["apparentTemperature"].to_f )

      StatsD.gauge('york.climate.humidity', humidity.to_f )
      StatsD.gauge('york.climate.windSpeed', currently["windSpeed"].to_f )
    end
  end

end
