# == Schema Information
#
# Table name: bandwidth_usages
#
#  id                :bigint(8)        not null, primary key
#  off_peak_download :float
#  off_peak_upload   :float
#  on_peak_download  :float
#  on_peak_upload    :float
#  period            :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class BandwidthUsage < ApplicationRecord
  require 'httparty'

  validates :on_peak_download, :on_peak_upload, :off_peak_download, :off_peak_upload, presence: true
  validates :period, uniqueness: true

   def self.fetch
    StatsD.measure('bandwidth_usage.save_job') do
      parse_usage_summary(0)
      parse_usage_summary(1)
      parse_usage_summary(2)
    end
  end

  def self.parse_usage_summary(slice)
    ENV['TEK_API'] || raise('no TEK_API provided')
    access_header = {"TekSavvy-APIKey" => ENV['TEK_API']}
    begin
      # tries ||= 10
      #detail
      # response = HTTParty.get('https://api.teksavvy.com/web/Usage/UsageRecords', headers: access_header)
      response = HTTParty.get('https://api.teksavvy.com/web/Usage/UsageSummaryRecords', headers: access_header)
      date = DateTime.strptime(response['value'][slice]['StartDate'].to_s, "%Y-%m-%d")
      @bandwidth = BandwidthUsage.where(period: date).first_or_create
      @bandwidth.on_peak_download = response['value'][slice]['OnPeakDownload']
      @bandwidth.off_peak_download = response['value'][slice]['OffPeakDownload']
      @bandwidth.on_peak_upload = response['value'][slice]['OnPeakUpload']
      @bandwidth.off_peak_upload = response['value'][slice]['OffPeakUpload']
      @bandwidth.save!
      logger.info("Successfully fetched bandwidth")
    rescue NoMethodError
      logger.error("Error, retrying")
      # retry unless (tries -= 1).zero?
    end
  end
end
