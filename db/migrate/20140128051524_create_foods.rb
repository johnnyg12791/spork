class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.belongs_to  :restaurant
    	t.string      :dish_name
    	t.string      :price
      t.text        :description
      t.float       :rating
      t.integer     :num_ratings
    	t.integer     :size
    	t.integer     :calories
    	t.integer     :nutrition
    	t.integer     :presentation
      t.timestamps
    end
  end
end

