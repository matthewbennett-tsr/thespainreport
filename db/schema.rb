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

ActiveRecord::Schema.define(version: 20170716161832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "headline"
    t.string   "lede"
    t.text     "body"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "type_id"
    t.string   "urgency"
    t.string   "main"
    t.string   "status"
    t.string   "caption"
    t.string   "source"
    t.string   "video"
    t.string   "summary"
    t.string   "summary_slug"
    t.boolean  "topstory",             default: false
    t.string   "email_to"
    t.string   "notification_slug"
    t.string   "notification_message"
    t.string   "short_lede"
    t.string   "short_headline"
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
    t.string   "keywords"
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

  add_index "entries", ["title"], name: "index_entries_on_title", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
    t.string   "slug"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "stripe_invoice_id"
    t.integer  "user_id"
    t.integer  "subscription_id"
    t.datetime "stripe_invoice_date"
    t.string   "stripe_invoice_item"
    t.integer  "stripe_invoice_quantity"
    t.integer  "stripe_invoice_price"
    t.integer  "stripe_invoice_subtotal"
    t.decimal  "stripe_invoice_tax_percent"
    t.integer  "stripe_invoice_tax_amount"
    t.integer  "stripe_invoice_total"
    t.string   "stripe_invoice_ip_country_code"
    t.string   "stripe_invoice_ip_country_code_2"
    t.string   "stripe_invoice_credit_card_country"
  end

  create_table "newsitems", force: :cascade do |t|
    t.text     "item"
    t.string   "source"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "slug"
    t.string   "url"
    t.string   "main"
    t.string   "imagesource"
    t.string   "status"
    t.string   "caption"
    t.integer  "article_id"
    t.string   "video"
    t.string   "summary"
    t.string   "summary_slug"
    t.string   "email_to"
    t.string   "short_slug"
    t.string   "short_headline"
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

  create_table "organisations", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "generalphone"
    t.string   "generalemail"
    t.string   "website"
    t.string   "name"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "youtube"
    t.integer  "province_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "towns"
  end

  create_table "quotes", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "quote"
    t.integer  "source_id"
    t.string   "messagetype"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "region"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
    t.string   "keywords"
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

  create_table "sources", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.string   "email1"
    t.string   "email2"
    t.string   "email3"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "phone3"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "youtube"
    t.string   "job"
    t.string   "blog"
    t.integer  "organisation_id"
    t.integer  "province_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string   "story"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "urgency"
    t.string   "status"
    t.string   "description"
    t.string   "keywords"
    t.datetime "last_active"
    t.integer  "parent_id"
  end

  create_table "stories_users", id: false, force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "user_id",  null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.string   "stripe_subscription_credit_card_country"
    t.integer  "user_id"
    t.string   "stripe_subscription_ip"
    t.string   "stripe_subscription_ip_country"
    t.string   "stripe_subscription_email"
    t.string   "stripe_subscription_plan"
    t.integer  "stripe_subscription_amount"
    t.integer  "stripe_subscription_quantity"
    t.decimal  "stripe_subscription_tax_percent"
    t.datetime "stripe_subscription_trial_end"
    t.datetime "stripe_subscription_current_period_start_date"
    t.datetime "stripe_subscription_current_period_end_date"
    t.string   "stripe_subscription_interval"
    t.string   "stripe_subscription_ip_country_name"
    t.boolean  "is_active"
  end

  create_table "taxes", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "tax_country_name"
    t.string   "tax_country_code"
    t.decimal  "tax_country_percent"
  end

  create_table "types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "name"
    t.string   "twitter"
    t.string   "avatar"
    t.text     "bio"
    t.boolean  "email_confirmed",          default: false
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
    t.boolean  "allow_access",             default: false
    t.boolean  "is_author",                default: false
    t.datetime "becomes_customer_date"
    t.string   "credit_card_id"
    t.string   "credit_card_brand"
    t.string   "credit_card_country"
    t.string   "credit_card_last4"
    t.integer  "credit_card_expiry_month"
    t.integer  "credit_card_expiry_year"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
