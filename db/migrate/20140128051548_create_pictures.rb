class CreatePictures < ActiveRecord::Migration
  def up
    create_table :pictures do |t|
      t.column :restaurant_id,  :integer 
      t.column :picture_id,  :integer 
      t.column :food_id,  :integer 
      t.column :drink_id,  :integer 
      t.column :file_name,	:string
      t.timestamps
    end
  end

  def down
  	drop_table	:pictures
  end
end
