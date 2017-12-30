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

ActiveRecord::Schema.define(version: 20171230010011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.integer  "race_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "difficulty"
    t.integer  "participants_count", default: 0
    t.string   "code"
    t.integer  "sort_order"
  end

  create_table "constraints", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "restrict"
    t.string   "string_value"
    t.integer  "integer_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counties", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", force: :cascade do |t|
    t.integer  "starting_no"
    t.integer  "team_id"
    t.integer  "category_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "gender"
    t.integer  "yob"
    t.date     "born"
    t.integer  "county_id"
    t.string   "id_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", force: :cascade do |t|
    t.string   "title"
    t.date     "held_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subtitle"
    t.string   "short_name"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "position"
    t.integer  "time_msec"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["participant_id"], name: "index_results_on_participant_id", using: :btree

  create_table "team_types", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "county_id"
    t.integer  "race_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participants_count", default: 0
    t.string   "title"
    t.integer  "team_type_id"
  end

end
