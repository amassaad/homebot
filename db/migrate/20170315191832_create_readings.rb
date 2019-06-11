# frozen_string_literal: true

class CreateReadings < ActiveRecord::Migration[5.0]
  def change
    create_table :readings do |t|
      t.datetime(:time)
      t.integer(:amount)
      t.integer(:cost)

      t.timestamps
    end
  end
end
