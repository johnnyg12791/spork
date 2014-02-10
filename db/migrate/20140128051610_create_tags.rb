class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.belongs_to :restaurant
	    t.column :description,	:string
      t.column :type, :string
      t.column :item_id, :integer
      t.timestamps
    end
  end

  def down
  	drop_table	:tags
  end
end
