class CreateBlacklistings < ActiveRecord::Migration[5.1]
  def change
    create_table :blacklistings do |t|
        t.integer :user_id
        t.integer :blacklist_id

      t.timestamps
    end
  end
end
