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

ActiveRecord::Schema.define(version: 20150720213243) do

  create_table "djs", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email",                     default: "", null: false
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
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "dj_name"
    t.boolean  "real_name_is_public"
    t.string   "public_email"
    t.string   "website"
    t.text     "about"
    t.text     "lists"
  end

  add_index "djs", ["email"], name: "index_djs_on_email", unique: true
  add_index "djs", ["reset_password_token"], name: "index_djs_on_reset_password_token", unique: true

  create_table "djs_roles", id: false, force: :cascade do |t|
    t.integer "dj_id"
    t.integer "role_id"
  end

  add_index "djs_roles", ["dj_id", "role_id"], name: "index_djs_roles_on_dj_id_and_role_id"

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
    t.integer  "status",                  default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "sub_request_information"
    t.string   "sub_request_group"
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

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

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
