# frozen_string_literal: true

json.extract! account, :id, :closeDateInDate, :lastUpdatedInDate, :currency, :interestRate, :dueAmt, :dueDate, :accountId, :fiLoginStatus, :addAccountDateInDate, :yodleeAccountNumberLastFour, :accountName, :status, :isClosed, :value, :accountType, :isError, :isActive, :fiName, :currentBalance, :created_at, :updated_at
json.url account_url(account, format: :json)
