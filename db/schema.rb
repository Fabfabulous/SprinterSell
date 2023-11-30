# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_30_113827) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.integer "status"
    t.integer "company_size"
    t.string "code_naf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "function"
    t.string "email"
    t.string "phone_number"
    t.string "service"
    t.string "comments"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "title"
    t.datetime "date"
    t.time "hour"
    t.bigint "user_id", null: false
    t.bigint "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content"
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_meetings_on_company_id"
    t.index ["contact_id"], name: "index_meetings_on_contact_id"
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "function"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contacts", "companies"
  add_foreign_key "meetings", "companies"
  add_foreign_key "meetings", "contacts"
  add_foreign_key "meetings", "users"
end
