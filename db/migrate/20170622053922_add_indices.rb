class AddIndices < ActiveRecord::Migration[5.1]
  def change
      add_index :users, :uid
      add_index :users, :age
      add_index :users, :gender
      add_index :users, :seeking
      add_index :users, :age_pref_low
      add_index :users, :age_pref_high
      add_index :users, :songkick_username
  end
end
