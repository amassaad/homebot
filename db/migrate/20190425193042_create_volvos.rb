# frozen_string_literal: true

class CreateVolvos < ActiveRecord::Migration[5.1]
  def change
    create_table :volvos do |t|
      t.integer(:vehicle_id)
      t.string(:position)
      t.string(:registration_number)
      t.integer(:odometer)
      t.integer(:lease_limit)
      t.integer(:fuel_amount)
      t.integer(:fuel_amount_level)
      t.string(:vin)

      t.timestamps
    end
  end
end
