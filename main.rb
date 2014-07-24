require 'rubygems'
require 'sinatra'
require 'pry'
require_relative 'helpers'
set :sessions, true


get '/' do
  erb :name
end

post '/name' do 
  if params[:name].lstrip[0]
    "name is legit"
    session[:name] = params[:name]
    session[:deck] = nil
    redirect "/game"
  else
    @error = "Type your name silly"
    erb :name
  end
end

get "/game" do
  if session[:name].nil?
    redirect "/"
  else
    if session[:deck].nil?  || session[:player_hand].nil? || session[:dealer_hand].nil?
      initialize_decks
      clear_hands 
      deal_card(session[:player_hand])
      deal_card(session[:player_hand])
      deal_card(session[:dealer_hand])
    end
    erb :game
  end
end

post '/game/player_action' do
  if params[:action] == "Hit"
    deal_card(session[:player_hand])
    session[:show_deal] = true
    session[:dealer_turn] = false
  else #Stay
    session[:dealer_turn] = true
    if hand_value(session[:dealer_hand]) < 17
      deal_card(session[:dealer_hand])
      session[:show_deal_top] = true
    else
      session[:show_deal_top] = false
    end
  end
  redirect "/game"
end

# post '/game/player_action' do
#   if params[:action] == "Hit"
#     deal_card(session[:player_hand])
#     session[:show_deal] = true
#   else #Stay
#     session[:dealer_turn] = true
#     while hand_value(session[:dealer_hand]) < 17
#      deal_card(session[:dealer_hand])
#     end
#   end
#   redirect "/game"
# end

post '/game/play_again' do
  initialize_decks
  clear_hands 
  deal_card(session[:player_hand])
  deal_card(session[:player_hand])
  deal_card(session[:dealer_hand])
  redirect "/game"
end

