class CreateJoinTableEventUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :events, :users do |t|
      t.index [:event_id, :user_id]
    end
  end
end
