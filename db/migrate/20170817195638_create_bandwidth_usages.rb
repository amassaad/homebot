# frozen_string_literal: true

class CreateBandwidthUsages < ActiveRecord::Migration[5.1]
  def change
    create_table :bandwidth_usages do |t|
      t.float(:on_peak_download)
      t.float(:on_peak_upload)
      t.float(:off_peak_download)
      t.float(:off_peak_upload)
      t.datetime(:period)

      t.timestamps
    end
  end
end
