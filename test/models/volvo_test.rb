# frozen_string_literal: true

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

require 'test_helper'

class VolvoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
