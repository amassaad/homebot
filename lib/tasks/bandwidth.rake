namespace :bandwidth do

  desc "emit latest bandwidth usage"
  task emit: :environment do
    next unless @bandwidth = BandwidthUsage.last
    StatsD.gauge('bandwidth.onpeak.download', @bandwidth.on_peak_download)
    StatsD.gauge('bandwidth.onpeak.upload', @bandwidth.on_peak_upload)
    StatsD.gauge('bandwidth.offpeak.download', @bandwidth.off_peak_download)
    StatsD.gauge('bandwidth.offpeak.upload', @bandwidth.off_peak_upload)
    StatsD.gauge('bandwidth.total.download', @bandwidth.off_peak_download + @bandwidth.on_peak_download)
    StatsD.gauge('bandwidth.total.upload', @bandwidth.off_peak_upload + @bandwidth.on_peak_upload)

    sleep(25)
  end

  desc "Import bandwidth Usage information to the db from the Teksavvy API "
  task fetch: :environment do
    BandwidthUsage.fetch
  end
end
