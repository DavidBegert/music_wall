class AddUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|  
      t.string :username
      t.string :email
      t.column :password, "char(40)"
      t.timestamps
    end
  end


end