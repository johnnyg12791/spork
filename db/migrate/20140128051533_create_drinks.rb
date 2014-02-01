class CreateDrinks < ActiveRecord::Migration
  def up
    create_table :drinks do |t|
      t.column :drink_name,	:string
      t.column :restaurant_id,  :integer
      t.column :price, :string
      t.column :alcoholic_strength, :integer
      t.column :description, :string
      t.timestamps
    end
  end

  def down
  	drop_table	:drinks
  end
end
