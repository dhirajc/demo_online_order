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

ActiveRecord::Schema.define(version: 20160420115130) do

  create_table "address_types", force: :cascade do |t|
    t.string "name",        limit: 64, null: false
    t.string "description"
  end

  add_index "address_types", ["name"], name: "index_address_types_on_name"

  create_table "addresses", force: :cascade do |t|
    t.integer  "address_type_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "state_name"
    t.string   "zip_code"
    t.string   "phone"
    t.string   "alternative_phone"
    t.boolean  "default"
    t.boolean  "billing_default"
    t.boolean  "active"
    t.integer  "country_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "addresses", ["address_type_id"], name: "index_addresses_on_address_type_id"
  add_index "addresses", ["addressable_id"], name: "index_addresses_on_addressable_id"
  add_index "addresses", ["country_id"], name: "index_addresses_on_country_id"
  add_index "addresses", ["state_id"], name: "index_addresses_on_state_id"

  create_table "cart_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cart_id"
    t.integer  "quantity"
    t.boolean  "active"
    t.integer  "item_type_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "variant_id"
  end

  add_index "cart_items", ["cart_id"], name: "index_cart_items_on_cart_id"
  add_index "cart_items", ["item_type_id"], name: "index_cart_items_on_item_type_id"
  add_index "cart_items", ["user_id"], name: "index_cart_items_on_user_id"
  add_index "cart_items", ["variant_id"], name: "index_cart_items_on_variant_id"

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "carts", ["customer_id"], name: "index_carts_on_customer_id"
  add_index "carts", ["user_id"], name: "index_carts_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "category_image_file_name"
    t.string   "category_image_content_type"
    t.integer  "category_image_file_size"
    t.datetime "category_image_updated_at"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "shipping_zone_id"
    t.boolean  "active"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "countries", ["shipping_zone_id"], name: "index_countries_on_shipping_zone_id"

  create_table "foods", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "category_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "food_image_file_name"
    t.string   "food_image_content_type"
    t.integer  "food_image_file_size"
    t.datetime "food_image_updated_at"
    t.string   "short_description"
    t.text     "product_keywords"
    t.datetime "available_at"
    t.datetime "deleted_at"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.boolean  "featured"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "order_id"
    t.decimal  "amount"
    t.string   "invoice_type"
    t.string   "state"
    t.boolean  "active"
    t.decimal  "credited_amount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "invoices", ["order_id"], name: "index_invoices_on_order_id"

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "food_id"
    t.integer  "order_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.decimal  "price"
    t.decimal  "total"
    t.string   "state"
    t.integer  "shipment_id"
    t.integer  "variant_id"
  end

  add_index "order_items", ["shipment_id"], name: "index_order_items_on_shipment_id"
  add_index "order_items", ["variant_id"], name: "index_order_items_on_variant_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "number"
    t.string   "ip_address"
    t.string   "email"
    t.string   "state"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.integer  "coupon_id"
    t.boolean  "active"
    t.boolean  "shipped"
    t.string   "shipments_count"
    t.datetime "calculated_at"
    t.datetime "completed_at"
    t.decimal  "credited_amount"
  end

  add_index "orders", ["bill_address_id"], name: "index_orders_on_bill_address_id"
  add_index "orders", ["coupon_id"], name: "index_orders_on_coupon_id"
  add_index "orders", ["ship_address_id"], name: "index_orders_on_ship_address_id"

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 30, null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "shipments", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "shipping_method_id"
    t.integer  "address_id"
    t.string   "tracking"
    t.string   "number"
    t.string   "state"
    t.string   "shipped_at"
    t.boolean  "active"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "shipments", ["address_id"], name: "index_shipments_on_address_id"
  add_index "shipments", ["order_id"], name: "index_shipments_on_order_id"
  add_index "shipments", ["shipping_method_id"], name: "index_shipments_on_shipping_method_id"

  create_table "shipping_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.string   "name"
    t.integer  "shipping_zone_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "shipping_methods", ["shipping_zone_id"], name: "index_shipping_methods_on_shipping_zone_id"

  create_table "shipping_zones", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "described_as"
    t.integer  "country_id"
    t.integer  "shipping_zone_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id"
  add_index "states", ["shipping_zone_id"], name: "index_states_on_shipping_zone_id"

  create_table "user_roles", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "firstname"
    t.string   "lastname"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "variants", force: :cascade do |t|
    t.integer  "food_id"
    t.string   "sku"
    t.string   "name"
    t.decimal  "price"
    t.decimal  "cost"
    t.datetime "deleted_at"
    t.boolean  "master"
    t.integer  "inventory_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "variants", ["food_id"], name: "index_variants_on_food_id"
  add_index "variants", ["inventory_id"], name: "index_variants_on_inventory_id"

end
