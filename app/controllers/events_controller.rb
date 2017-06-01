class EventsController < ApplicationController

    def index
        events = Event.all
        render json: events
    end

    def destroy
        
        # User.destroy_all
        # Event.destroy_all
        # Artist.destroy_all
        Matching.destroy_all
        Blacklisting.destroy_all
        Potentialing.destroy_all

        # ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'users'")
        # ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'events'")
        # ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'artists'")
        ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'matchings'")
        ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'blacklistings'")
        ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'potentialings'")

        render json: {"destroy func": "done"}

    end

end
