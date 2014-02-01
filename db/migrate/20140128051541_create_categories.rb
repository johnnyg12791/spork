class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.column :category,	:string
      t.column :restaurant_id,	:integer 
      t.column :picture_id,  :integer 
      t.column :food_id,  :integer 
      t.column :drink_id,  :integer 
      t.timestamps
    end
  end

  def down
  	drop_table	:categories
  end
end
