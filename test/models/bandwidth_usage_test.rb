require 'test_helper'

class BandwidthUsageTest < ActiveSupport::TestCase
  test "that BandwidthUsage can be saved" do
    rawresponse = File.new(Rails.root.join("test/fixtures/tekapi.txt"))
    stub_request(:get, "https://api.teksavvy.com/web/Usage/UsageSummaryRecords").
    to_return(rawresponse)

    assert true, BandwidthUsage.fetch
  end
end
