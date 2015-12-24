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

ActiveRecord::Schema.define(version: 20151224234138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "headline"
    t.string   "lede"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "type_id"
    t.string   "urgency"
    t.string   "main"
    t.string   "status"
    t.string   "caption"
    t.string   "source"
    t.string   "video"
  end

  create_table "articles_categories", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  create_table "articles_regions", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "region_id"
  end

  create_table "articles_stories", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "story_id"
  end

  create_table "articles_types", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "type_id"
  end

  create_table "audios", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "category"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

  create_table "categories_newsitems", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "newsitem_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "entries", force: :cascade do |t|
    t.integer  "feed_id"
    t.string   "atom_id"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feeds", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
    t.string   "slug"
  end

  create_table "newsitems", force: :cascade do |t|
    t.text     "item"
    t.string   "source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
    t.string   "url"
    t.string   "main"
    t.string   "imagesource"
    t.string   "status"
    t.string   "caption"
    t.integer  "article_id"
    t.string   "video"
  end

  create_table "newsitems_categories", id: false, force: :cascade do |t|
    t.integer "newsitem_id"
    t.integer "category_id"
  end

  create_table "newsitems_regions", id: false, force: :cascade do |t|
    t.integer "newsitem_id"
    t.integer "region_id"
  end

  add_index "newsitems_regions", ["newsitem_id"], name: "index_newsitems_regions_on_newsitem_id", using: :btree
  add_index "newsitems_regions", ["region_id"], name: "index_newsitems_regions_on_region_id", using: :btree

  create_table "newsitems_stories", id: false, force: :cascade do |t|
    t.integer "newsitem_id"
    t.integer "story_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "region"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

  create_table "salesemails", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "to"
    t.string   "delay_number"
    t.string   "delay_period"
    t.string   "subject"
    t.text     "message"
    t.string   "send_order"
  end

  create_table "stories", force: :cascade do |t|
    t.string   "story"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "urgency"
    t.string   "status"
    t.string   "description"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "twitter"
    t.string   "avatar"
    t.text     "bio"
    t.boolean  "email_confirmed",        default: false
    t.string   "confirm_token"
    t.string   "password_digest"
    t.string   "role"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "sign_up_url"
    t.string   "emailpref"
    t.string   "stripe_customer_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
