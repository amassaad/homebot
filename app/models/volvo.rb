# == Schema Information
#
# Table name: volvos
#
#  id                  :bigint(8)        not null, primary key
#  fuel_amount         :integer
#  fuel_amount_level   :integer
#  lease_limit         :integer
#  odometer            :integer
#  position            :string
#  registration_number :string
#  vin                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  vehicle_id          :integer
#

class Volvo < ApplicationRecord
  VIN = ENV['VOC_VIN']
  USER = ENV['VOC_USER']
  PASS = ENV['VOC_PASS']
  LEASE_START = ENV['VOC_LEASE_START']

  SERVICE_URL = "https://vocapi-na.wirelesscar.net/customerapi/rest/v3.0/vehicles/#{VIN}/status"

  def self.car
    uri = URI(SERVICE_URL)

    Net::HTTP.start(uri.host, uri.port,
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(USER, PASS)

      request['X-Device-Id'] = "Device"
      request['X-OS-Type'] = "Android"
      request['X-Originator-Type'] = "App"
      request['X-OS-Version'] = "22"
      request['Content-Type'] = "application/json"

      response = http.request(request)
      data = JSON.parse(response.body)
      puts response.body

      if car = Volvo.first
        car.odometer = data['odometer']
        puts data['odometer']
        car.fuel_amount = data['fuelAmount']
        car.fuel_amount_level = data['fuelAmountLevel']
        car.save!
      else
        Volvo.create
      end
    end
  end

  def self.lease
    if car = Volvo.first
      a = Date.parse(LEASE_START)
      b = Date.today
      days = b - a
      car.lease_limit = days
      car.save!
    end
  end
end
