#TODO: CATEGORIES
class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.belongs_to :restaurant
      t.belongs_to :drink
      t.belongs_to :food
      t.column :category,	:string
      t.column :type, :string ## determines if category is for drink, food, restaurant, etc.
      t.column :item_id, :integer #determines item id for table of type type
      t.timestamps
    end
  end

  def down
  	drop_table	:categories
  end
end
