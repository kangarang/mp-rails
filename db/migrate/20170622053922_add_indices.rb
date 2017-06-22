class AddIndices < ActiveRecord::Migration[5.1]
  def change
      add_index :users, [:uid, :age, :gender, :seeking]
  end
end
