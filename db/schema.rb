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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130104150918) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.integer  "race_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "difficulty"
    t.integer  "participants_count", :default => 0
    t.string   "code"
    t.integer  "sort_order"
  end

  create_table "constraints", :force => true do |t|
    t.integer  "category_id"
    t.string   "restrict"
    t.string   "string_value"
    t.integer  "integer_value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "counties", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participants", :force => true do |t|
    t.integer  "starting_no"
    t.integer  "team_id"
    t.integer  "category_id"
    t.integer  "person_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "gender"
    t.integer  "yob"
    t.date     "born"
    t.integer  "county_id"
    t.string   "id_string"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "races", :force => true do |t|
    t.string   "title"
    t.date     "held_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "subtitle"
    t.string   "short_name"
  end

  create_table "results", :force => true do |t|
    t.integer  "position"
    t.integer  "time_msec"
    t.integer  "participant_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "results", ["participant_id"], :name => "index_results_on_participant_id"

  create_table "teams", :force => true do |t|
    t.integer  "county_id"
    t.integer  "race_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "participants_count", :default => 0
  end

end
