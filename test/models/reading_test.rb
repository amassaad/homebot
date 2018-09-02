# frozen_string_literal: true

# == Schema Information
#
# Table name: readings
#
#  id         :integer          not null, primary key
#  amount     :integer
#  cost       :integer
#  ratetype   :string
#  time       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_readings_on_time  (time) UNIQUE
#

require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  test "Reading time should not exist already in the database" do
    data = { time: 'Friday June 2, 2017 12:00 AM - 01:00 AM',
             ratetype: 'Off-Peak',
             amount: 1840,
             cost: 16 }

    assert true, Reading.create!(data)

    assert_raise ActiveRecord::RecordInvalid do
      assert_not Reading.create!(data)
    end
  end
end
