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

ActiveRecord::Schema.define(version: 2023_05_13_201832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
  end

  create_table "categories_exercises", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "exercise_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_categories_exercises_on_category_id"
    t.index ["exercise_id"], name: "index_categories_exercises_on_exercise_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.integer "parent_id"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.text "video_link"
    t.bigint "exercise_id"
    t.boolean "published", default: true
    t.text "description"
    t.integer "level", default: 0
    t.interval "duration"
    t.integer "visibility", default: 0
    t.boolean "versions_enabled", default: true
    t.float "goal_end"
    t.float "goal_start"
    t.bigint "goal_label_id"
    t.string "slug"
    t.index ["exercise_id"], name: "index_exercises_on_exercise_id"
    t.index ["goal_label_id"], name: "index_exercises_on_goal_label_id"
    t.index ["slug"], name: "index_exercises_on_slug"
    t.index ["user_id"], name: "index_exercises_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id"
    t.bigint "following_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follower_id", "following_id"], name: "index_follows_on_follower_id_and_following_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
    t.index ["following_id"], name: "index_follows_on_following_id"
  end

  create_table "goal_labels", force: :cascade do |t|
    t.string "label"
  end

  create_table "goal_settings", force: :cascade do |t|
    t.bigint "exercise_id"
    t.bigint "user_id"
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "user_id"], name: "index_goal_settings_on_exercise_id_and_user_id", unique: true
    t.index ["exercise_id"], name: "index_goal_settings_on_exercise_id"
    t.index ["user_id"], name: "index_goal_settings_on_user_id"
  end

  create_table "media", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "file_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_media_on_user_id"
  end

  create_table "media_exercises", force: :cascade do |t|
    t.integer "medium_id"
    t.integer "exercise_id"
    t.index ["medium_id", "exercise_id"], name: "media_exercise"
  end

  create_table "practices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_practices_on_user_id"
  end

  create_table "practices_exercises", force: :cascade do |t|
    t.bigint "practice_id", null: false
    t.bigint "exercise_id", null: false
    t.interval "duration", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id"], name: "index_practices_exercises_on_exercise_id"
    t.index ["practice_id"], name: "index_practices_exercises_on_practice_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "favorites", default: [], array: true
    t.jsonb "avatar_data"
    t.text "bio"
    t.integer "role", default: 1
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users"
  add_foreign_key "exercises", "exercises"
  add_foreign_key "exercises", "goal_labels"
  add_foreign_key "exercises", "users"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "follows", "users", column: "following_id"
  add_foreign_key "media", "users"
  add_foreign_key "practices", "users"
  add_foreign_key "practices_exercises", "exercises"
  add_foreign_key "practices_exercises", "practices"
end
