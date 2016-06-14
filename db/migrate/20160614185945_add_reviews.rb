class AddReviews < ActiveRecord::Migration

  def change
    create_table :reviews do |t|
      t.references :user
      t.references :song
      t.integer :rating
      t.text :post
      t.timestamps
    end

  end


end