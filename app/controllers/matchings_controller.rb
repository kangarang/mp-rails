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

        send_arr = []

        @user = User.where(uid: params[:uid])[0]

        @user.matches.each do |it|
            if it.matches.include?(@user)
                our_rooms = @user.rooms & it.rooms
                send_obj = {user: it, events: @user.events & it.events, artists: @user.artists & it.artists, room: our_rooms[0]["name"]}
                send_arr.push(send_obj)
            end
        end

        render json: {
            "matches": send_arr
        }
    end


end
