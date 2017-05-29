class CreatePotentialings < ActiveRecord::Migration[5.1]
  def change
    create_table :potentialings do |t|
        t.integer :user_id
        t.integer :potential_id

      t.timestamps
    end
  end
end
