class CreateHours < ActiveRecord::Migration
  def up
    create_table :hours do |t|
   		  t.belongs_to  :restaurant
   	    t.column :sunday,	:string
   	    t.column :monday,	:string
   	    t.column :tuesday,	:string
   	    t.column :wednesday, :string
   	    t.column :thursday,	:string
   	    t.column :friday,	:string
   	    t.column :saturday,	:string 
    end
  end

  def down
  	drop_table	:hours
  end
end
