class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
	  t.column :description,	:string
	  t.column :restaurant_id,	:integer 
      t.column :picture_id,  :integer 
      t.column :food_id,  :integer 
      t.column :drink_id,  :integer 
      t.timestamps
    end
  end

  def down
  	drop_table	:tags
  end
end
