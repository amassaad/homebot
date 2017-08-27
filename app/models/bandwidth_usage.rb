class BandwidthUsage < ApplicationRecord
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
    require 'httparty'

    access_header = {"TekSavvy-APIKey" => ENV['TEK_API']}
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
  end
end
