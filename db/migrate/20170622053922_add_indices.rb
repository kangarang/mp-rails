class AddIndices < ActiveRecord::Migration[5.1]
  def change
      add_index :potentialings, [:potential_id, :user_id]
      add_index :matchings, [:match_id, :user_id]
      add_index :blacklistings, [:blacklist_id, :user_id]

      add_index :users, [:age, :gender, :seeking]

      add_index :users, :uid
      add_index :events, :eid
      add_index :artists, :aid
  end
end
