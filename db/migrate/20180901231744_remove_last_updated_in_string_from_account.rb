# frozen_string_literal: true

class RemoveLastUpdatedInStringFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :lastUpdatedInString, :string
  end
end
