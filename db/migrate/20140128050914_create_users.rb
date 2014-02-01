class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.column :first_name,	:string
      t.column :last_name, :string
      t.column :location, :string
      t.column :rating_score, :integer
      t.timestamps
    end
  end

  def down
  	drop_table	:users
  end
end
