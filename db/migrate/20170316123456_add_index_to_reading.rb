class AddIndexToReading < ActiveRecord::Migration[5.0]
  def change
    add_index :readings, :time, unique: true
  end
end
