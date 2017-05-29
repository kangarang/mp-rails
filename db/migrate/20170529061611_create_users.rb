class CreateUsers < ActiveRecord::Migration[5.1]
    def change
        create_table :users do |t|
            t.string :first_name
            t.string :last_name
            t.string :songkick_username
            t.string :gender
            t.string :location
            t.string :seeking
            t.string :height
            t.string :ethnicity
            t.string :eth_pref
            t.string :body_type
            t.string :profession
            t.string :photo_url
            t.string :uid

            t.boolean :also_friends
            t.boolean :just_friends

            t.integer :age
            t.integer :age_pref_low
            t.integer :age_pref_high
            t.timestamps
        end
    end
end
