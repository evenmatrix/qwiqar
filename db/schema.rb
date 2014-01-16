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

ActiveRecord::Schema.define(:version => 20131229123056) do

  create_table "carriers", :force => true do |t|
    t.string   "name"
    t.string   "country_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "carriers", ["name", "country_code"], :name => "index_carriers_on_name_and_country_code", :unique => true

  create_table "contact_groups", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "about"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "contact_groups", ["user_id"], :name => "index_contact_groups_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.integer  "user_id"
    t.integer  "contact_group_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "contacts", ["phone_number"], :name => "index_contacts_on_phone_number", :unique => true
  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "credits", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deposits", :force => true do |t|
    t.integer  "wallet_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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

  create_table "items", :force => true do |t|
    t.decimal  "amount",        :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "order_id"
    t.integer  "itemable_id"
    t.string   "itemable_type"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "state"
  end

  add_index "items", ["itemable_id"], :name => "index_items_on_itemable_id"
  add_index "items", ["itemable_type"], :name => "index_items_on_itemable_type"
  add_index "items", ["order_id"], :name => "index_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "payment_processor_id"
    t.string   "state"
    t.integer  "transaction_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "response_code"
    t.string   "response_description"
    t.string   "payment_method"
  end

  add_index "orders", ["payment_processor_id"], :name => "index_orders_on_payment_processor_id"
  add_index "orders", ["transaction_id"], :name => "index_orders_on_transaction_id", :unique => true
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "payment_processors", :force => true do |t|
    t.string   "name"
    t.string   "gateway_interface"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer  "carrier_id"
    t.string   "number"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "phone_numbers", ["entity_id"], :name => "index_phone_numbers_on_entity_id"
  add_index "phone_numbers", ["number"], :name => "index_phone_numbers_on_number", :unique => true

  create_table "requisitions", :force => true do |t|
    t.decimal  "amount",     :precision => 10, :scale => 0, :default => 0, :null => false
    t.integer  "vault_id"
    t.integer  "top_up_id"
    t.string   "state"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  create_table "top_ups", :force => true do |t|
    t.string   "message"
    t.integer  "sender_id"
    t.string   "top_genie_id"
    t.string   "top_genie_status"
    t.integer  "receiver_id"
    t.integer  "phone_number_id"
    t.integer  "contact_id"
    t.boolean  "delivered"
    t.string   "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "top_ups", ["contact_id"], :name => "index_top_ups_on_contact_id"
  add_index "top_ups", ["phone_number_id"], :name => "index_top_ups_on_phone_number_id"
  add_index "top_ups", ["receiver_id"], :name => "index_top_ups_on_receiver_id"
  add_index "top_ups", ["sender_id"], :name => "index_top_ups_on_sender_id"
  add_index "top_ups", ["top_genie_id"], :name => "index_top_ups_on_top_genie_id"

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

  create_table "vaults", :force => true do |t|
    t.string   "name"
    t.decimal  "balance",    :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  create_table "wallets", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "balance",    :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "wallets", ["user_id"], :name => "index_wallets_on_user_id"

end
