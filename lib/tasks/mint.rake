# frozen_string_literal: true

namespace :mint do
  desc "emit latest mint account status"
  task emit: :environment do
    Account.emit_mint
  end

  desc "Import Mint Account information to the db from the Mint API "
  task fetch: :environment do
    Account.update_from_api
  end
end
