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

ActiveRecord::Schema[7.2].define(version: 2026_03_26_103858) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "histories", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.datetime "viewed_at", null: false
    t.boolean "understood", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["topic_id", "viewed_at"], name: "index_histories_on_topic_id_and_viewed_at"
    t.index ["user_id", "topic_id"], name: "index_histories_on_user_id_and_topic_id", unique: true
    t.index ["user_id"], name: "index_histories_on_user_id"
    t.index ["viewed_at"], name: "index_histories_on_viewed_at"
  end

  create_table "topics", force: :cascade do |t|
    t.string "category", default: "web_basics", null: false
    t.string "title", null: false
    t.string "topic_type", default: "concept", null: false
    t.string "status", default: "seeded", null: false
    t.text "summary"
    t.text "steps"
    t.text "deep_dive"
    t.jsonb "references", default: [], null: false
    t.datetime "generated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "title"], name: "index_topics_on_category_and_title", unique: true
    t.index ["status"], name: "index_topics_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "histories", "topics"
  add_foreign_key "histories", "users"
end
