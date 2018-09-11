# frozen_string_literal: true

namespace :mint do
  desc "emit latest mint account status"
  task emit: :environment do
    Account.bank.active.each do |account|
      puts "Name: #{account.accountName} | Value: #{account.value}"

      StatsD.gauge('mint.account.bank.balance', account.value, tags: ["account_name:#{account.accountName}"])
      StatsD.gauge('mint.account.bank.interest_rate', account.interestRate || 0, tags: ["account_name:#{account.accountName}"])
    end

    Account.credit.active.each do |account|
      puts "Name: #{account.accountName} | Value: #{account.value}"

      StatsD.gauge('mint.account.credit.balance', account.value, tags: ["account_name:#{account.accountName}"])
      StatsD.gauge('mint.account.credit.interest_rate', account.interestRate|| 0, tags: ["account_name:#{account.accountName}"])
    end
    sleep(25)
  end

  desc "Import Mint Account information to the db from the Mint API "
  task fetch: :environment do
    Account.update_from_api
  end
end
