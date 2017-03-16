namespace :readings do
  desc "Import readings to the db from an excel file of hourly readings"

  task import_from_file: :environment do
    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open 'public/hourly.xls'
    sheet1 = book.worksheets[0]
    sheet1.each 4 do |row|
      unless row[0].nil?
        puts row unless Rails.env.production?

        r = Reading.new(time:     row[0],
                        ratetype: row[1].to_s,
                        amount:   amount_format(row[2]),
                        cost:     cost_format(row[3]))
        begin
          r.save!
        rescue ActiveRecord::RecordInvalid => e
          if e.message == 'Validation failed: Time has already been taken'
            next
          end
        end

      end
    end
  end

  def amount_format(amt)
    amt.gsub('kWh', '').to_f * 1000
  end

  def cost_format(cost)
    (cost * 100).to_i
  end
end

# Time Period
# Rate Type
# Consumption
# Cost

# Mar 14, 2017 01:00 AM - 02:00 AM
# Off-Peak
# 0.43kWh
# 0.04
