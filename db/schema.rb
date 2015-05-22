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

ActiveRecord::Schema.define(version: 20150511111410) do

  create_table "airlines", force: true do |t|
    t.string   "openflight_id"
    t.string   "name"
    t.string   "alias"
    t.string   "iata"
    t.string   "iaco"
    t.string   "callsign"
    t.string   "country"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "airports", force: true do |t|
    t.string   "openflight_id"
    t.string   "name"
    t.string   "city"
    t.string   "country"
    t.string   "iata"
    t.string   "icao"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "altitude"
    t.decimal  "timezone"
    t.string   "dst"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_results", force: true do |t|
    t.integer  "search_id"
    t.integer  "airline_id"
    t.text     "results"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_results", ["airline_id"], name: "index_search_results_on_airline_id"
  add_index "search_results", ["search_id"], name: "index_search_results_on_search_id"

  create_table "searches", force: true do |t|
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.date     "departure_date"
    t.date     "arrival_date"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["destination_id"], name: "index_searches_on_destination_id"
  add_index "searches", ["origin_id"], name: "index_searches_on_origin_id"

  create_table "uniteds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
