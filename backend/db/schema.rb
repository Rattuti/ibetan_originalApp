# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_02_17_124915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "event_dates"
    t.string "cost"
    t.string "childcare"
    t.string "color"
    t.integer "article_id"
    t.integer "favorites", default: 0
    t.index ["title"], name: "index_articles_on_title", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "email"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "article_id"
    t.string "title"
    t.text "content"
    t.string "start_date"
    t.string "end_date"
    t.boolean "judge", default: false
    t.bigint "user_id"
    t.string "color"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "article_id"
    t.integer "click", default: 0, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "name"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role", default: "user", null: false
    t.string "avatar"
    t.datetime "confirmed_at"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "encrypted_password", default: "", null: false
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "events", "users"
end
