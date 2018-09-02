# frozen_string_literal: true

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

require 'test_helper'

class BandwidthUsageTest < ActiveSupport::TestCase
  test "that BandwidthUsage can be saved" do
    rawresponse = File.new(Rails.root.join("test/fixtures/tekapi.txt"))
    stub_request(:get, "https://api.teksavvy.com/web/Usage/UsageSummaryRecords")
      .to_return(rawresponse)

    assert true, BandwidthUsage.fetch
  end
end
