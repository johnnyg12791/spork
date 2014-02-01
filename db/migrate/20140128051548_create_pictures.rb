class CreatePictures < ActiveRecord::Migration
  def up
    create_table :pictures do |t|
      t.column :file_name,	:string
      t.column :date_time,  :datetime
      t.column :user_id,    :integer
      t.column :type, :integer
      t.timestamps
    end
  end

  def down
  	drop_table	:pictures
  end
end
