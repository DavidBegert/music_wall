class AddSongs < ActiveRecord::Migrate

  def change 
    create table :songs do |t|
      t.string :title
      t.string :artist
      t.string :url
      t.timestamps
    end
  end
end