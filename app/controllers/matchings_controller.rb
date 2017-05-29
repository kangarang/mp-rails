class MatchingsController < ApplicationController

    def index
        puts 'matching index'
        matchings = Matching.all
        render json: matchings
    end

    def potentials_index
        potentials = Potentialing.all
        render json: potentials
    end

    def show_black
        all_black = Blacklisting.all
        render json: all_black
    end

    def show_matches
        user = User.where(uid: params[:uid])[0]
        user_matches = user.matches

        new_array = user_matches.select{|it| it.matches.include?(user)}

        send_arr = []

        new_array.each do |one|
            our_room = (user.rooms & one.rooms)[0]["name"]
            send_obj = {user: one, events: user.events & one.events, artists: one.artists & user.artists, room: our_room}
            send_arr.push(send_obj)
        end

        render json: {
            "matches": send_arr
        }
    end


end
