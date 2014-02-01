class CreateRestaurants < ActiveRecord::Migration
  def up
    create_table :restaurants do |t|
      t.column :location,	:string
      t.column :description,	:string
      t.column :hours,		:string
      t.column :menu_id, :integer
      t.timestamps
    end
  end

  def down
  	drop_table	:restaurants
  end
end
