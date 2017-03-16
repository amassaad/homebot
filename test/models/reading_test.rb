require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  test "Reading time should not exist already in the database" do
    data = {time: 'Mar 15, 2017 12:00 AM - 01:00 AM',
      ratetype: 'Off-Peak',
      amount: 1840,
      cost: 16}

    assert true, Reading.create!(data)

    assert_raise ActiveRecord::RecordInvalid do
      assert_not Reading.create!(data)
    end
  end
end
