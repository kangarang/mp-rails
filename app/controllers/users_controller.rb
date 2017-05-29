class UsersController < ApplicationController
    attr_accessor :songkick_matches, :events, :user, :users, :users_matched_prefs, :artists

    def initialize
        @songkick_matches = []
        @events
        @user
        @users
        @users_matched_prefs = []
        @artists
    end

    def index
        puts "\n   ISAAC"
        puts ""
        @users = User.all
        # render json: @users
    end

    def create
        if User.exists?(uid: params[:uid])
            @user = User.where(uid: params[:uid])[0]
            self.update
        else
            # @user = User.new(uid: params[:uid], photo_url: params[:photo_url], first_name: params[:first_name].capitalize, last_name: params[:last_name].capitalize, songkick_username: params[:songkick_username], gender: params[:gender], location: params[:location], seeking: params[:seeking], height: params[:height], ethnicity: params[:ethnicity], eth_pref: params[:eth_pref], body_type: params[:body_type], profession: params[:profession], also_friends: params[:also_friends], just_friends: params[:just_friends], age: params[:age], age_pref_low: params[:age_pref_low], age_pref_high: params[:age_pref_high])

            @user = User.new(user_params)
            if @user.save
                puts '\nNew user saved.'
                self.find_matches_using_prefs
            end
        end
    end

    def new_day_button
      @user = User.where(uid: params[:uid])[0]
      self.find_matches_using_prefs
    end

    def render_potentials
        @user = User.where(uid: params[:uid])[0]
        if @user
            self.not_first_time
            # self.find_matches_using_prefs # to get events and artists
        else
            render json: {'error': "no user"}
        end
    end

    def not_first_time
      potentials = @user.potentials

      my_blacklists = @user.blacklists
      blacklist_users = []

      my_blacklists.each do |elem|
          blacklist_users.push(User.find(elem[:them].to_i))
      end

      potentials = potentials - blacklist_users

      send_arr = []

      potentials.each do |one|
        send_obj = {user: one, events: @user.events & one.events, artists: one.artists & @user.artists}
        send_arr.push(send_obj)
      end

      render json: {"songkick_matches": send_arr}
    end

    def find_matches_using_prefs
        # @users_matched_prefs = User.where(gender: @user.seeking, location: @user.location, seeking: @user.gender, ethnicity: @user.eth_pref, eth_pref: @user.ethnicity, age: @user.age_pref_low..@user.age_pref_high).where("age_pref_low <= ?", @user.age).where("age_pref_high >= ?", @user.age)

        @users_matched_prefs = User.where(gender: @user.seeking, seeking: @user.gender, location: @user.location, age: @user.age_pref_low..@user.age_pref_high).where("age_pref_low <= ?", @user.age).where("age_pref_high >= ?", @user.age)

        my_blacklists = @user.blacklists
        blacklist_users = []

        my_blacklists.each do |elem|
            blacklist_users.push(User.find(elem[:them].to_i))
        end

        @users_matched_prefs = @users_matched_prefs - blacklist_users

        self.songkick
    end

    def songkick
        self.songkick_events
        self.songkick_artists
        self.add_artists
        self.match_by_events
    end

    def songkick_events
        events_one = self.get_sk_events('1')
        @events.push(events_one)

        if (@events.size > 49)
            events_two = self.get_sk_events('2')
            if (events_two.size > 0)
                @events.concat(events_two)
            end
        end

        @events
    end

    def get_sk_events(page)
        events_data = HTTParty.get("http://api.songkick.com/api/3.0/users/#{@user.songkick_username}/calendar.json?reason=tracked_artist&apikey=#{ENV["SONG_KICK"]}&page=#{page}&per_page=50")

        events_data["resultsPage"]["results"]["calendarEntry"]
    end

    def get_sk_artists(page)
        artists_data = HTTParty.get("http://api.songkick.com/api/3.0/users/#{@user.songkick_username}/artists/tracked.json?apikey=d8WwMhgEnQQpnBKb&page=#{page}&per_page=50")
        
        artists_data["resultsPage"]["results"]["artist"]
    end

    def songkick_artists
        artists_one = self.get_sk_artists('1')
        @artists.push(artists_one)

        if (@artists.size > 49)
            artists_two = self.get_sk_artists('2')
            if (artists_two.size > 0)
                @artists.concat(artists_two)
                if (@artists.size > 99)
                    artists_three = self.get_sk_artists('3')
                    if (artists_three.size > 0)
                        @artists.concat(artists_three)
                        if (@artists.size > 149)
                            artists_four = self.get_sk_artists('4')
                            if (artists_four.size > 0)
                                @artists.concat(artists_four)
                            end
                        end

                    end
                end
            end
        end

        @artists
    end

    def add_artists
        @artists.each do |single|
            if Artist.exists?(aid: single["id"])
                dupe_artist = Artist.where(aid: single["id"])[0]
                if dupe_artist.users.include?(@user)
                else
                    @user.artists << dupe_artist
                end
            else
                new_artist = Artist.new(name: single["displayName"], aid: single["id"])
                if new_artist.save
                    if @user.artists.include?(new_artist)
                    else
                        @user.artists << new_artist
                    end
                end
            end
        end
    end

    def match_by_events
        duplicate_events = []
        if @users_matched_prefs.size > 0

            @users_matched_prefs.each do |same_prefs|

                shared_artists = same_prefs.artists & @user.artists

                events_array = []
                matchie = {}

                @events.each do |it|
                    # this function should only be written once.
                    # make a separate function that first separates the old events from the new ones
                    # then, using activerecord, find the event matches

                    if it["event"]["type"] === "Concert"
                        if Event.exists?(eid: it["event"]["id"])
                            dupe_event = Event.where(eid: it["event"]["id"])[0]
                            duplicate_events.push(dupe_event)
                            if dupe_event.users.include?(same_prefs)
                              if @user.potentials.include?(same_prefs)
                              else
                                @user.potentials << same_prefs
                                same_prefs.potentials << @user
                              end
                              matchie = same_prefs
                              events_array.push(dupe_event)
                              if dupe_event.users.include?(@user)
                              else
                                  dupe_event.users << @user
                              end
                            end
                        else # if it's a new event
                            self.handle_new_event(it)
                        end # if there are duplicate_events or not
                    end # concerts only
                end

                if events_array.size > 0
                    # has something to do with scope. does the array have to be pushed outside?????
                    event_user_hash = {events: events_array, user: matchie, artists: shared_artists}
                    @songkick_matches.push(event_user_hash)
                end

            end # end each do
        else # no matches
            @events.each do |it|
                if it["event"]["type"] === "Concert"
                    if Event.exists?(eid: it["event"]["id"])
                        dupe_event = Event.where(eid: it["event"]["id"])[0]
                        duplicate_events.push(dupe_event)
                        if dupe_event.users.include?(@user)
                        else
                            dupe_event.users << @user
                        end
                    else # if it's a new event
                        self.handle_new_event(it)
                    end # if there are duplicate_events or not
                end # concerts only
            end
        end

        render json: {"songkick_matches": @songkick_matches, "dupe_events": duplicate_events, "artists": @user.artists}
    end

    def handle_new_event(it)
        new_event = Event.new(eid: it["event"]["id"], event_name: it["event"]["displayName"], date: it["event"]["start"]["date"], uri: it["event"]["uri"], venue: it["event"]["venue"]["displayName"], reason_artist: it["reason"]["trackedArtist"][0]["displayName"])
        if new_event.save
            new_event.users << @user
        end
    end

    def black_list
        @user = User.where(uid: params[:uid])[0]
        other_user = User.find(params[:id])

        if Blacklist.exists?(me: @user.id, them: other_user.id)
            render json: {"your blacklists": @user.blacklists, "theirs": other_user.blacklists}
        else
            new_bl = Blacklist.new(me: @user.id, them: other_user.id)
            if new_bl.save
                new_bl.users << @user
                self.find_matches_using_prefs
            end
        end
    end

    def yes_please
        @user = User.where(uid: params[:uid])[0]
        other_user = User.find(params[:id])

        # if the other user wants me
        if other_user.matches.include?(@user)
            # just in case the re-render hasn't taken place
            if @user.matches.include?(other_user)
                render json: {"exists": @user.matches, "their wants": other_user.matches}
            else
                # blacklist the user to not show up again as a potential
                new_bl = Blacklist.new(me: @user.id, them: other_user.id)
                if new_bl.save
                    new_room = Room.new(name: @user.uid + other_user.uid)
                    if new_room.save
                        new_room.users << @user
                        new_room.users << other_user
                        new_bl.users << @user
                        @user.matches << other_user
                        # re-render the potential matches
                        self.find_matches_using_prefs
                    end
                end
            end
        else # they haven't said yes yet
            # just in case the re-render hasn't taken place
            if Matching.exists?(user_id: @user.id, match_id: other_user.id)
                render json: {"still loading": "please wait"}
            else
                # blacklist the user to not show up again as a potential
                new_bl = Blacklist.new(me: @user.id, them: other_user.id)
                if new_bl.save
                    new_bl.users << @user
                    @user.matches << other_user
                    # re-render the potential matches
                    self.find_matches_using_prefs
                end
            end
        end
    end

    def update
        user = User.where(uid: params[:uid])[0]

        updated = user.update(first_name: params[:first_name].capitalize, last_name: params[:last_name].capitalize, songkick_username: params[:songkick_username], gender: params[:gender], location: params[:location], seeking: params[:seeking], height: params[:height], ethnicity: params[:ethnicity], eth_pref: params[:eth_pref], body_type: params[:body_type], profession: params[:profession], also_friends: params[:also_friends], just_friends: params[:just_friends], age: params[:age], age_pref_low: params[:age_pref_low], age_pref_high: params[:age_pref_high])

        if updated
            self.render_potentials
        else
            render json: {'error': updated.errors}
        end
    end

    def get_profile
        user = User.where(uid: params[:uid])[0]

        if user
          render json: user
        else
          render json: {'error': "no user"}
        end

    end

    private

    def user_params
        params.require(:user).permit(:uid, :photo_url, :first_name, :last_name, :songkick_username, :gender, :location, :seeking, :height, :ethnicity, :eth_pref, :body_type, :profession, :also_friends, :just_friends, :age, :age_pref_high, :age_pref_low)
    end
end
