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

ActiveRecord::Schema.define(version: 20160330170328) do

  create_table "availables", force: :cascade do |t|
    t.integer  "user_id",    default: 1
    t.datetime "day",                        null: false
    t.boolean  "eve",        default: true
    t.boolean  "free",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "availables", ["user_id"], name: "index_availables_on_user_id"

  create_table "cabinets", force: :cascade do |t|
    t.integer  "performance_id", null: false
    t.integer  "product_id",     null: false
    t.integer  "quantity",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cabinets", ["performance_id", "product_id"], name: "index_cabinets_on_performance_id_and_product_id"
  add_index "cabinets", ["performance_id"], name: "index_cabinets_on_performance_id"
  add_index "cabinets", ["product_id"], name: "index_cabinets_on_product_id"

  create_table "distributeds", force: :cascade do |t|
    t.integer  "performance_id",                 null: false
    t.integer  "product_id",                     null: false
    t.datetime "curtain",                        null: false
    t.boolean  "eve",            default: true
    t.integer  "quantity"
    t.integer  "language",       default: 0,     null: false
    t.integer  "general",        default: 0
    t.integer  "representative", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "isinfrared",     default: false
    t.boolean  "scan",           default: false
  end

  add_index "distributeds", ["performance_id", "product_id"], name: "index_distributeds_on_performance_id_and_product_id"
  add_index "distributeds", ["performance_id"], name: "index_distributeds_on_performance_id"
  add_index "distributeds", ["product_id"], name: "index_distributeds_on_product_id"

  create_table "performances", force: :cascade do |t|
    t.integer  "theater_id",      default: 1
    t.string   "name",                            null: false
    t.integer  "duration",        default: 180
    t.integer  "intermission",    default: 90
    t.datetime "opening"
    t.datetime "closeing"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "specialservices", default: false
  end

  add_index "performances", ["theater_id"], name: "index_performances_on_theater_id"

  create_table "products", force: :cascade do |t|
    t.string   "name",                    null: false
    t.integer  "payrate",    default: 48
    t.string   "comments"
    t.integer  "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scans", force: :cascade do |t|
    t.integer  "performance_id",                  null: false
    t.datetime "monday",                          null: false
    t.boolean  "specialservices", default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "scans", ["performance_id"], name: "index_scans_on_performance_id"

  create_table "theaters", force: :cascade do |t|
    t.string   "name",                                                               null: false
    t.string   "address"
    t.string   "city",                           default: "New York"
    t.string   "state",                          default: "NY"
    t.string   "zip"
    t.string   "phone"
    t.string   "company"
    t.string   "comments"
    t.string   "commentsentrance",               default: "Enter by the stage door"
    t.string   "commentsworklocation",           default: "Console location"
    t.string   "commentslock",         limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                  null: false
    t.string   "phone",           default: "2125551234"
    t.string   "phonetype",       default: "sprint"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "txtupdate",       default: true
    t.boolean  "alert",           default: false
    t.integer  "alerttime",       default: 3
    t.boolean  "schedule",        default: true
    t.boolean  "admin",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
