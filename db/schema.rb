ActiveRecord::Schema[7.1].define(version: 2026_06_02_000000) do
  create_table "reviews", force: :cascade do |t|
    t.string "author", null: false
    t.string "source", null: false
    t.text "body", null: false
    t.integer "rating"
    t.integer "sentiment", default: 0, null: false
    t.float "score", default: 0.0, null: false
    t.text "emotions"
    t.boolean "flagged", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_reviews_on_created_at"
    t.index ["flagged"], name: "index_reviews_on_flagged"
    t.index ["sentiment"], name: "index_reviews_on_sentiment"
  end
end

