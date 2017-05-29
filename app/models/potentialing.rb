class Potentialing < ApplicationRecord
    belongs_to :user, :foreign_key => "user_id", :class_name => "User"
    belongs_to :potential, :foreign_key => "potential_id", :class_name => "User"
end
