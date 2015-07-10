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

ActiveRecord::Schema.define(version: 20150518200410) do

  create_table "djs", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "um_affiliation"
    t.string   "um_dept"
    t.integer  "umid"
    t.string   "experience"
    t.string   "referral"
    t.string   "interests"
    t.text     "statement"
    t.string   "stage1"
    t.string   "demotape"
    t.string   "stage2"
    t.string   "apprenticeship_freeform1"
    t.string   "apprenticeship_freeform2"
    t.string   "apprenticeship_specialty1"
    t.string   "apprenticeship_specialty2"
    t.string   "broadcasters_exam"
    t.integer  "most_recent_email"
    t.boolean  "active"
    t.text     "roles"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "djs_specialty_shows", id: false, force: :cascade do |t|
    t.integer "dj_id",             null: false
    t.integer "specialty_show_id", null: false
  end

  add_index "djs_specialty_shows", ["specialty_show_id", "dj_id"], name: "index_djs_specialty_shows_on_specialty_show_id_and_dj_id", unique: true

  create_table "episodes", force: :cascade do |t|
    t.integer  "show_id"
    t.string   "show_type"
    t.datetime "beginning"
    t.datetime "ending"
    t.text     "notes"
    t.integer  "dj_id"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "episodes", ["dj_id"], name: "index_episodes_on_dj_id"
  add_index "episodes", ["show_type", "show_id"], name: "index_episodes_on_show_type_and_show_id"

  create_table "freeform_shows", force: :cascade do |t|
    t.integer  "semester_id"
    t.integer  "dj_id"
    t.string   "name"
    t.integer  "weekday"
    t.datetime "beginning"
    t.datetime "ending"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "freeform_shows", ["dj_id"], name: "index_freeform_shows_on_dj_id"
  add_index "freeform_shows", ["semester_id"], name: "index_freeform_shows_on_semester_id"

  create_table "semesters", force: :cascade do |t|
    t.datetime "beginning"
    t.datetime "ending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signoff_instances", force: :cascade do |t|
    t.string   "on"
    t.string   "signed"
    t.datetime "at"
    t.integer  "signoff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "signoff_instances", ["signoff_id"], name: "index_signoff_instances_on_signoff_id"

  create_table "signoffs", force: :cascade do |t|
    t.string   "on"
    t.text     "times"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "name"
    t.string   "artist"
    t.string   "album"
    t.string   "label"
    t.integer  "year"
    t.boolean  "request"
    t.datetime "at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "episode_id"
  end

  add_index "songs", ["episode_id"], name: "index_songs_on_episode_id"

  create_table "specialty_shows", force: :cascade do |t|
    t.integer  "semester_id"
    t.integer  "coordinator_id"
    t.string   "name"
    t.integer  "weekday"
    t.datetime "beginning"
    t.datetime "ending"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "specialty_shows", ["coordinator_id"], name: "index_specialty_shows_on_coordinator_id"
  add_index "specialty_shows", ["semester_id"], name: "index_specialty_shows_on_semester_id"

  create_table "talk_shows", force: :cascade do |t|
    t.integer  "semester_id"
    t.integer  "dj_id"
    t.string   "name"
    t.integer  "weekday"
    t.datetime "beginning"
    t.datetime "ending"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "talk_shows", ["dj_id"], name: "index_talk_shows_on_dj_id"
  add_index "talk_shows", ["semester_id"], name: "index_talk_shows_on_semester_id"

end
