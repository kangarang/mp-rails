class CreateEvents < ActiveRecord::Migration[5.1]
    def change
        create_table :events do |t|
            t.string :event_name
            t.string :date
            t.string :uri
            t.string :venue
            t.string :reason_artist
            t.integer :eid
            t.timestamps
        end
    end
end
