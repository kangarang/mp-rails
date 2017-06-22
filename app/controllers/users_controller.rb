class UsersController < ApplicationController

    def initialize
        @songkick_matches = []
        @events
        @user
        @users
        @users_matched_prefs = []
        @artists
        @dupe_events = []
    end

    def index
        puts "\n    ISAAC"
        puts ""
        @users = User.all
        render json: @users
    end

    def show
        render json: Person.find(params[:id])
    end

    def find_user
        if @user
            return @user
        else
            if session[:current_user_id]
                @user = User.find(session[:current_user_id])
            else
                @user = User.where(uid: params[:uid])[0]
                session[:current_user_id] = @user.id
            end
        end
    end

    def create
        self.find_user
        if @user
            self.update
        else
            @user = User.new(user_params)
            if @user.save
                session[:current_user_id] = @user.id
                puts '\n    New user saved'
                self.find_matches_using_prefs
            end
        end
    end

    def new_day_button
        self.find_user
        self.find_matches_using_prefs
    end

    def render_potentials
        self.find_user
        if @user
            self.not_first_time
        else
            render json: {'error': "no user"}
        end
    end

    def not_first_time
        true_potentials = @user.potentials - @user.blacklists
        sk_matches = []
        true_potentials.each do |it|
            send_obj = {
                user: it,
                events: @user.events & it.events,
                artists: @user.artists & it.artists
            }
            sk_matches.push(send_obj)
        end

        render json: {"songkick_matches": sk_matches}
    end

    def find_matches_using_prefs
        # @users_matched_prefs = User.where(gender: @user.seeking, location: @user.location, seeking: @user.gender, ethnicity: @user.eth_pref, eth_pref: @user.ethnicity, age: @user.age_pref_low..@user.age_pref_high).where("age_pref_low <= ?", @user.age).where("age_pref_high >= ?", @user.age)

        @users_matched_prefs = User.where(gender: @user.seeking, seeking: @user.gender, location: @user.location, age: @user.age_pref_low..@user.age_pref_high).where("age_pref_low <= ?", @user.age).where("age_pref_high >= ?", @user.age)

        @users_matched_prefs = @users_matched_prefs - @user.blacklists

        self.songkick
    end

    def songkick
        self.songkick_events
        self.add_events
        self.songkick_artists
        self.add_artists
        self.match_by_events
    end

    def songkick_events
        events_one = self.get_sk_events('1')
        @events = events_one

        if (@events.size > 49)
            events_two = self.get_sk_events('2')
            if (events_two.size > 0)
                @events.concat(events_two)
            end
        end

        # if @events.size > 0
        # end
    end

    def get_sk_events(page)
        songkick_api_key = ENV["SONG_KICK"]
        events_data = HTTParty.get("http://api.songkick.com/api/3.0/users/#{@user.songkick_username}/calendar.json?reason=tracked_artist&apikey=#{songkick_api_key}&page=#{page}&per_page=50")

        events_data["resultsPage"]["results"]["calendarEntry"]
    end

    def add_events
        @events.each do |it|
            if it["event"]["type"] === "Concert"
                if Event.exists?(eid: it["event"]["id"])
                    dupe_event = Event.where(eid: it['event']['id'])[0]
                    @dupe_events.push(dupe_event)

                    if @user.events.include?(dupe_event)
                    else
                        @user.events << dupe_event
                    end
                else
                    new_event = Event.new(eid: it["event"]["id"], event_name: it["event"]["displayName"], date: it["event"]["start"]["date"], uri: it["event"]["uri"], venue: it["event"]["venue"]["displayName"], reason_artist: it["reason"]["trackedArtist"][0]["displayName"])

                    if new_event.save
                        @user.events << new_event
                    end
                end
            end
        end
    end

    def get_sk_artists(page)
        songkick_api_key = ENV["SONG_KICK"]
        artists_data = HTTParty.get("http://api.songkick.com/api/3.0/users/#{@user.songkick_username}/artists/tracked.json?apikey=#{songkick_api_key}&page=#{page}&per_page=50")
        artists_data["resultsPage"]["results"]["artist"]
    end

    def songkick_artists
        artists_one = self.get_sk_artists('1')
        @artists = artists_one

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
                            if artists_four
                                @artists.concat(artists_four)
                            end
                        end
                    end
                end
            end
        end
        # if @artists.size > 0
        #     self.add_artists
        # end
    end

    def add_artists
        @artists.each do |single|
            if Artist.exists?(aid: single["id"])
                dupe_artist = Artist.where(aid: single["id"])[0]

                if @user.artists.include?(dupe_artist)
                else
                    @user.artists << dupe_artist
                end

            else
                new_artist = Artist.new(name: single["displayName"], aid: single["id"])

                if new_artist.save
                    @user.artists << new_artist
                end
            end
        end
    end

    def match_by_events

        @users_matched_prefs.each do |same_prefs|

            shared_artists = same_prefs.artists.includes(:users) & @user.artists
            shared_events = same_prefs.events.includes(:users) & @user.events

            puts 'shared::::::'
            puts shared_artists

            if shared_artists.length > 0 && shared_events.length > 0
                if @user.potentials.exclude?(same_prefs)
                    @user.potentials << same_prefs
                    same_prefs.potentials << @user
                end
                event_user_hash = {events: shared_events, artists: shared_artists, user: same_prefs}
                @songkick_matches.push(event_user_hash)
            end
        end

        render json: {"songkick_matches": @songkick_matches, "dupe_events": @dupe_events, "artists": @user.artists}

    end

    def black_list
        @user = User.where(uid: params[:uid])[0]
        # self.find_user
        other_user = User.find(params[:id])

        if @user.blacklists.include?(other_user)
            render json: {"your blacklists": @user.blacklists, "theirs": other_user.blacklists}
        else
            @user.blacklists << other_user
        end
    end

    def yes_please
        @user = User.where(uid: params[:uid])[0]
        # self.find_user
        other_user = User.find(params[:id])
        # other user wants too
        if other_user.matches.include?(@user)
            # just in case the re-render hasn't taken place
            if @user.matches.include?(other_user)
                render json: {"exists": @user.matches, "their wants": other_user.matches}
            else
                @user.matches << other_user
                @user.blacklists << other_user
                new_room = Room.new(name: @user.uid + other_user.uid)
                if new_room.save
                    @user.rooms << new_room
                    other_user.rooms << new_room
                    self.find_matches_using_prefs
                end
            end
        else # they haven't said yes yet
            if @user.matches.include?(other_user)
                render json: {"still loading": "please wait"}
            else
                @user.matches << other_user
                @user.blacklists << other_user
                self.find_matches_using_prefs
            end
        end
    end

    def update
        self.find_user

        updated = @user.update(first_name: params[:first_name].capitalize, last_name: params[:last_name].capitalize, songkick_username: params[:songkick_username], gender: params[:gender], location: params[:location], seeking: params[:seeking], height: params[:height], ethnicity: params[:ethnicity], eth_pref: params[:eth_pref], body_type: params[:body_type], profession: params[:profession], also_friends: params[:also_friends], just_friends: params[:just_friends], age: params[:age], age_pref_low: params[:age_pref_low], age_pref_high: params[:age_pref_high])

        if updated
            self.render_potentials
        else
            render json: {'error': updated.errors}
        end
    end

    def get_profile
        self.find_user

        if @user
          render json: @user
        else
          render json: {'error': "no user"}
        end

    end

    private

    def user_params
        params.require(:user).permit(:uid, :photo_url, :first_name, :last_name, :songkick_username, :gender, :location, :seeking, :height, :ethnicity, :eth_pref, :body_type, :profession, :also_friends, :just_friends, :age, :age_pref_high, :age_pref_low)
    end
end
