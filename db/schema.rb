# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_16_215405) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guesses", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "treasure_id", null: false
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "long", precision: 10, scale: 6
    t.integer "distance_from_treasure"
    t.boolean "winner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_guesses_on_player_id"
    t.index ["treasure_id"], name: "index_guesses_on_treasure_id"
  end

  create_table "long_lived_tokens", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.string "hashed_token"
    t.datetime "expiry"
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_token"], name: "index_long_lived_tokens_on_hashed_token", unique: true
    t.index ["player_id"], name: "index_long_lived_tokens_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temporary_tokens", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.string "hashed_token"
    t.datetime "expiry"
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_token"], name: "index_temporary_tokens_on_hashed_token", unique: true
    t.index ["player_id"], name: "index_temporary_tokens_on_player_id"
  end

  create_table "treasures", force: :cascade do |t|
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "long", precision: 10, scale: 6
    t.text "hint"
    t.boolean "found", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "guesses", "players"
  add_foreign_key "guesses", "treasures"
  add_foreign_key "long_lived_tokens", "players"
  add_foreign_key "temporary_tokens", "players"
end
