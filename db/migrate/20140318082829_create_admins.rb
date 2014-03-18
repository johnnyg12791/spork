class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.belongs_to  :user
      t.belongs_to  :restaurant
      

      t.timestamps
    end
  end
end
