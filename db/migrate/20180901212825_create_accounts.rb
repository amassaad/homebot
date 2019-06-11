# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.datetime(:closeDateInDate)
      t.datetime(:lastUpdatedInDate)
      t.string(:currency)
      t.float(:interestRate)
      t.float(:dueAmt)
      t.datetime(:dueDate)
      t.integer(:accountId)
      t.string(:fiLoginStatus)
      t.datetime(:addAccountDateInDate)
      t.string(:yodleeAccountNumberLastFour)
      t.string(:accountName)
      t.string(:lastUpdatedInString)
      t.integer(:status)
      t.boolean(:isClosed)
      t.float(:value)
      t.string(:accountType)
      t.boolean(:isError)
      t.boolean(:isActive)
      t.string(:fiName)
      t.float(:currentBalance)

      t.timestamps
    end
  end
end
