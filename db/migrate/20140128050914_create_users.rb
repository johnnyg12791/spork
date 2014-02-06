class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.column :first_name,	:string
      t.column :last_name, :string
      t.column :fb_id, :integer
      t.column :latitude, :decimal, {:precision=>10, :scale=>6}
      t.column :longitude, :decimal, {:precision=>10, :scale=>6}
      t.column :rating_score, :integer
      t.timestamps
    end
  end

  def down
  	drop_table	:users
  end
end
