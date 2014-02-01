class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.column :user_id,	:integer 
      t.column :content,	:string
      t.column :restaurant_id,	:integer 
      t.column :picture_id,  :integer 
      t.column :food_id,  :integer 
      t.column :drink_id,  :integer 

      t.timestamps
    end
  end

  def down
  	drop_table	:comments
  end
end
