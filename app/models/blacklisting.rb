class Blacklisting < ApplicationRecord
    belongs_to :user, :foreign_key => "user_id", :class_name => "User"
    belongs_to :blacklist, :foreign_key => "blacklist_id", :class_name => "User"
end
