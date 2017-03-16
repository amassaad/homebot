class AddTypeToReading < ActiveRecord::Migration[5.0]
  def change
    add_column :readings, :ratetype, :string
  end
end
