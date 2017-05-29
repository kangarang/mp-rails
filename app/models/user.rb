class User < ApplicationRecord
    has_many :matchings, :foreign_key => "user_id", :class_name => "Matching"
    has_many :matches, :through => :matchings

    has_many :potentialings, :foreign_key => "user_id", :class_name => "Potentialing"
    has_many :potentials, :through => :potentialings

    has_many :blacklistings, :foreign_key => "user_id", :class_name => "Blacklisting"
    has_many :blacklists, :through => :blacklistings

    has_and_belongs_to_many :events
    has_and_belongs_to_many :artists
    has_and_belongs_to_many :rooms
end
