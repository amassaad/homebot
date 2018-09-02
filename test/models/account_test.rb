# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                          :bigint(8)        not null, primary key
#  accountId                   :integer
#  accountName                 :string
#  accountType                 :string
#  addAccountDateInDate        :datetime
#  closeDateInDate             :datetime
#  currency                    :string
#  currentBalance              :float
#  dueAmt                      :float
#  dueDate                     :datetime
#  fiLoginStatus               :string
#  fiName                      :string
#  interestRate                :float
#  isActive                    :boolean
#  isClosed                    :boolean
#  isError                     :boolean
#  lastUpdatedInDate           :datetime
#  status                      :integer
#  value                       :float
#  yodleeAccountNumberLastFour :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
