class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :imageable, polymorphic: true
      t.string :file_name
      t.string :picture_type
      t.datetime :date_time

      t.timestamps
    end
  end
end
