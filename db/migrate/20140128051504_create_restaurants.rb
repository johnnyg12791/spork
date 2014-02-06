class CreateRestaurants < ActiveRecord::Migration
  def up
    create_table :restaurants do |t|
      t.column :name, :string
      t.column :latitude, :decimal, {:precision=>10, :scale=>6}
      t.column :longitude, :decimal, {:precision=>10, :scale=>6}
      t.column :description,	:string
      t.column :hours,		:datetime
      t.timestamps
    end
  end

  def down
  	drop_table	:restaurants
  end
end
