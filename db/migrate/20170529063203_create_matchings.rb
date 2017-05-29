class CreateMatchings < ActiveRecord::Migration[5.1]
  def change
    create_table :matchings do |t|
        t.integer :user_id
        t.integer :match_id

      t.timestamps
    end
  end
end
