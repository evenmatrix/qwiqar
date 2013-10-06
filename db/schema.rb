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

ActiveRecord::Schema.define(:version => 20130928054518) do

  create_table "deposits", :force => true do |t|
    t.decimal  "amount",     :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "wallet_id"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "deposits", ["wallet_id"], :name => "index_deposits_on_wallet_id"

  create_table "feedback_messages", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "message"
    t.string   "email",      :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "line_items", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",      :precision => 10, :scale => 0, :default => 0, :null => false
    t.string   "description"
    t.integer  "order_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  add_index "line_items", ["item_id"], :name => "index_line_items_on_item_id"
  add_index "line_items", ["item_type"], :name => "index_line_items_on_item_type"
  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.decimal  "total_amount", :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "user_id"
    t.string   "state"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "phone_numbers", :force => true do |t|
    t.string   "carrier"
    t.string   "number"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phone_numbers", ["number"], :name => "index_phone_numbers_on_number", :unique => true
  add_index "phone_numbers", ["user_id"], :name => "index_phone_numbers_on_user_id"

  create_table "top_ups", :force => true do |t|
    t.decimal  "amount",       :precision => 10, :scale => 0, :default => 0, :null => false
    t.string   "message"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "top_ups", ["recipient_id"], :name => "index_top_ups_on_recipient_id"
  add_index "top_ups", ["sender_id"], :name => "index_top_ups_on_sender_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "wallets", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "balance",    :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "wallets", ["user_id"], :name => "index_wallets_on_user_id"

end
