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
require 'open3'
require 'json'

class Account < ApplicationRecord
  scope :closed, -> { where(isClosed: true) }

  def self.update_from_api
    username = ENV['MINT_USER']
    password = ENV['MINT_PASS']

    stdout, status = Open3.capture2('mintapi', username.to_s, password.to_s)
    raise StandardError unless status.success?

    # file = File.read(Rails.root.join('accounts.json'))

    accounts = JSON.parse(stdout)
    accounts.each do |account|
      Account .where(
        accountId: account['accountId']
      ).first_or_create
        .update(
          accountName: account['accountName'],
          accountType: account['accountType'],
          addAccountDateInDate: account['addAccountDateInDate'],
          closeDateInDate: account['closeDateInDate'],
          currency: account['currency'],
          currentBalance: account['currentBalance'],
          dueAmt: account['dueAmt'],
          dueDate: account['dueDate'],
          fiLoginStatus: account['fiLoginStatus'],
          fiName: account['fiName'],
          interestRate: account['interestRate'],
          isActive: account['isActive'],
          isClosed: account['isClosed'],
          isError: account['isError'],
          lastUpdatedInDate: account['lastUpdatedInDate'],
          status: account['status'],
          value: account['value'],
          yodleeAccountNumberLastFour: account['yodleeAccountNumberLastFour']
        )
    end
  end
end
