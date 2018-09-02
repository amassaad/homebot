# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180901231744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "closeDateInDate"
    t.datetime "lastUpdatedInDate"
    t.string "currency"
    t.float "interestRate"
    t.float "dueAmt"
    t.datetime "dueDate"
    t.integer "accountId"
    t.string "fiLoginStatus"
    t.datetime "addAccountDateInDate"
    t.string "yodleeAccountNumberLastFour"
    t.string "accountName"
    t.integer "status"
    t.boolean "isClosed"
    t.float "value"
    t.string "accountType"
    t.boolean "isError"
    t.boolean "isActive"
    t.string "fiName"
    t.float "currentBalance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bandwidth_usages", force: :cascade do |t|
    t.float "on_peak_download"
    t.float "on_peak_upload"
    t.float "off_peak_download"
    t.float "off_peak_upload"
    t.datetime "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "readings", id: :serial, force: :cascade do |t|
    t.datetime "time"
    t.integer "amount"
    t.integer "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ratetype"
    t.index ["time"], name: "index_readings_on_time", unique: true
  end

end
