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

ActiveRecord::Schema.define(version: 20170922212222) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "djs", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.string   "phone"
    t.string   "email",                  default: "",   null: false
    t.string   "um_affiliation"
    t.string   "um_dept"
    t.string   "umid"
    t.boolean  "active",                 default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
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
    t.index ["email"], name: "index_djs_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_djs_on_reset_password_token", unique: true, using: :btree
  end

  create_table "djs_roles", id: false, force: :cascade do |t|
    t.integer "dj_id"
    t.integer "role_id"
    t.index ["dj_id", "role_id"], name: "index_djs_roles_on_dj_id_and_role_id", using: :btree
  end

  create_table "djs_specialty_shows", id: false, force: :cascade do |t|
    t.integer "dj_id",             null: false
    t.integer "specialty_show_id", null: false
    t.index ["specialty_show_id", "dj_id"], name: "index_djs_specialty_shows_on_specialty_show_id_and_dj_id", unique: true, using: :btree
  end

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
    t.integer  "trainee_id"
    t.boolean  "shadowed"
    t.index ["beginning"], name: "index_episodes_on_beginning", using: :btree
    t.index ["dj_id"], name: "index_episodes_on_dj_id", using: :btree
    t.index ["show_type", "show_id"], name: "index_episodes_on_show_type_and_show_id", using: :btree
    t.index ["trainee_id"], name: "index_episodes_on_trainee_id", using: :btree
  end

  create_table "freeform_shows", force: :cascade do |t|
    t.integer  "semester_id"
    t.integer  "dj_id"
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "times"
    t.text     "description", default: "", null: false
    t.text     "website"
    t.index ["dj_id"], name: "index_freeform_shows_on_dj_id", using: :btree
    t.index ["semester_id"], name: "index_freeform_shows_on_semester_id", using: :btree
  end

  create_table "playlist_editors", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_playlist_editors_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_playlist_editors_on_reset_password_token", unique: true, using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "semesters", force: :cascade do |t|
    t.datetime "beginning"
    t.datetime "ending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "setbreaks", force: :cascade do |t|
    t.datetime "at"
    t.integer  "episode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["at"], name: "index_setbreaks_on_at", using: :btree
    t.index ["episode_id"], name: "index_setbreaks_on_episode_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key"
    t.jsonb    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signoff_instances", force: :cascade do |t|
    t.string   "on"
    t.string   "signed"
    t.datetime "at"
    t.integer  "signoff_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "with_cart_name", default: false, null: false
    t.text     "cart_name"
    t.index ["at"], name: "index_signoff_instances_on_at", using: :btree
    t.index ["signoff_id"], name: "index_signoff_instances_on_signoff_id", using: :btree
  end

  create_table "signoffs", force: :cascade do |t|
    t.string   "on"
    t.text     "times"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "until"
    t.integer  "status"
    t.integer  "random_interval"
    t.boolean  "random",          default: false
    t.boolean  "with_cart_name",  default: false, null: false
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
    t.boolean  "local"
    t.boolean  "new"
    t.index ["at"], name: "index_songs_on_at", using: :btree
    t.index ["episode_id"], name: "index_songs_on_episode_id", using: :btree
  end

  create_table "specialty_shows", force: :cascade do |t|
    t.integer  "semester_id"
    t.integer  "coordinator_id"
    t.string   "name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "times"
    t.text     "description",    default: "", null: false
    t.text     "website"
    t.index ["coordinator_id"], name: "index_specialty_shows_on_coordinator_id", using: :btree
    t.index ["semester_id"], name: "index_specialty_shows_on_semester_id", using: :btree
  end

  create_table "sub_requests", force: :cascade do |t|
    t.integer  "episode_id"
    t.integer  "status"
    t.string   "reason"
    t.string   "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["episode_id"], name: "index_sub_requests_on_episode_id", using: :btree
  end

  create_table "talk_shows", force: :cascade do |t|
    t.integer  "semester_id"
    t.integer  "dj_id"
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "times"
    t.string   "topic",       default: "", null: false
    t.text     "description", default: "", null: false
    t.text     "website"
    t.index ["dj_id"], name: "index_talk_shows_on_dj_id", using: :btree
    t.index ["semester_id"], name: "index_talk_shows_on_semester_id", using: :btree
  end

  create_table "tips", force: :cascade do |t|
    t.string   "uid"
    t.string   "receipt_data"
    t.string   "product_id"
    t.decimal  "value"
    t.string   "name"
    t.string   "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "trainees", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "um_affiliation"
    t.string   "um_dept"
    t.string   "umid"
    t.string   "experience"
    t.string   "referral"
    t.string   "interests"
    t.text     "statement"
    t.string   "demotape"
    t.string   "stage2"
    t.string   "apprenticeships"
    t.string   "broadcasters_exam"
    t.integer  "most_recent_email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "dj_id"
    t.boolean  "disqualified",      default: false, null: false
    t.index ["dj_id"], name: "index_trainees_on_dj_id", using: :btree
  end

  add_foreign_key "trainees", "djs"
end
