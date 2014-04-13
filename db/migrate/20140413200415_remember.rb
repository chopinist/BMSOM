class Remember < ActiveRecord::Migration
  def change

    create_table "remember_tokens", force: true do |t|
      t.integer "user_id"
      t.string  "remember_token"
    end

    create_table "reservations", force: true do |t|
      t.integer  "user_id"
      t.integer  "room_id"
      t.datetime "time"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "lock_version"
    end

    create_table "rooms", force: true do |t|
      t.string   "name",                                 null: false
      t.boolean  "contains_grand_piano", default: false, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "users", force: true do |t|
      t.string   "first_name",                        null: false
      t.string   "last_name",                         null: false
      t.string   "username",                          null: false
      t.string   "email"
      t.string   "password_digest"
      t.string   "instrument",      default: "Other", null: false
      t.boolean  "admin",           default: false,   null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

  end
end
