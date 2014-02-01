class CreateFoods < ActiveRecord::Migration
  def up
    create_table :foods do |t|
    	t.column :dish_name,	:string
    	t.column :restaurant_id,	:integer
    	t.column :price,	:string
    	t.column :description,	:string
    	t.column :size,		:integer
    	t.column :calories,		:integer
    	t.column :nutrition,	:string
    	t.column :presentation,		:integer
      t.timestamps
    end
  end

  def down
  	drop_table	:foods
  end
end

