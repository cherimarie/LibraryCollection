# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150128224244) do

  create_table "authors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_by"
  end

  create_table "book_authors", force: true do |t|
    t.integer  "book_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contribution_id"
  end

  create_table "book_keywords", force: true do |t|
    t.integer  "book_id"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "book_uploads", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
    t.string   "genre"
  end

  create_table "books", force: true do |t|
    t.string   "title"
    t.string   "isbn"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publisher"
    t.string   "publish_date"
    t.string   "publication_place"
    t.string   "language"
    t.integer  "pages"
    t.string   "location"
    t.boolean  "selected",          default: false
    t.boolean  "available",         default: true
    t.integer  "count",             default: 1
  end

  create_table "contributions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation", null: false
  end

  create_table "keywords", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loans", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.date     "start_date"
    t.date     "due_date"
    t.date     "returned_date"
    t.integer  "renewal_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "user_uploads", force: true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "notes"
    t.string   "name"
    t.string   "phone"
    t.string   "preferred_first_name"
    t.text     "address"
    t.string   "identification"
    t.boolean  "do_not_lend"
    t.string   "username"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
