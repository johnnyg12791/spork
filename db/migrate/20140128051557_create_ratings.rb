class CreateRatings < ActiveRecord::Migration
  def up
    create_table :ratings do |t|
      t.references :ratable, polymorphic: true
      t.belongs_to :user
      t.column :type, :string
  	  t.column :score,	:integer
      t.column :comment, :string # CAN BE EMPTY IF JUST SCORE
      t.column :date_time,  :datetime

      t.timestamps
    end
  end

  def down
  	drop_table :ratings
  end
end
