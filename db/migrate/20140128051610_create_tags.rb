class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
	    t.column :description,	:string
      t.column :type, :integer
      t.column :item_id, :integer
      t.timestamps
    end
  end

  def down
  	drop_table	:tags
  end
end
