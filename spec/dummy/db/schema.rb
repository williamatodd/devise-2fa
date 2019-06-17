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

ActiveRecord::Schema.define(version: 2019_03_12_222952) do

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "otp_auth_secret"
    t.string "otp_recovery_secret"
    t.boolean "otp_enabled", default: false, null: false
    t.boolean "otp_mandatory", default: false, null: false
    t.datetime "otp_enabled_on"
    t.integer "otp_failed_attempts", default: 0, null: false
    t.integer "otp_recovery_counter", default: 0, null: false
    t.string "otp_persistence_seed"
    t.string "otp_session_challenge"
    t.datetime "otp_challenge_expires"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["otp_challenge_expires"], name: "index_users_on_otp_challenge_expires"
    t.index ["otp_session_challenge"], name: "index_users_on_otp_session_challenge", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
