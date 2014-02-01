class CreateRatings < ActiveRecord::Migration
  def up
    create_table :ratings do |t|
	  t.column :item_id,	:integer # DO WE NEED TO DIFFERENTIATE FOOD/DRINK/RESTAURANT ID
	  t.column :score,	:integer
	  t.column :user_id,	:integer
      t.timestamps
    end
  end

  def down
  	drop_table :ratings
  end
end
