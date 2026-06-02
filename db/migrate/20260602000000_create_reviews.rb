class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :author, null: false
      t.string :source, null: false
      t.text :body, null: false
      t.integer :rating
      t.integer :sentiment, null: false, default: 0
      t.float :score, null: false, default: 0.0
      t.text :emotions
      t.boolean :flagged, null: false, default: false

      t.timestamps
    end

    add_index :reviews, :sentiment
    add_index :reviews, :flagged
    add_index :reviews, :created_at
  end
end

