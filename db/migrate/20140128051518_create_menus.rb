class CreateMenus < ActiveRecord::Migration


 ### DON’T REALLY NEED MENU - JUST GO TO FOOD/DRINK TABLES AND GET RESTAURANT ID MATCH


  def up
    create_table :menus do |t|
      t.column :food_id,	:integer
      t.column :drink_id,	:integer
      t.timestamps
    end
  end

  def down
  	drop_table	:menus
  end
end
