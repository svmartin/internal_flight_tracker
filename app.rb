# app.rb
require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'yaml'

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  @flights = YAML.load_stream(File.read('flights.yaml'))
end

helpers do
  #
end

not_found do
  "/"
end

get "/" do
  erb :home, layout: :layout
end

get "/flights" do
  erb :flights, layout: :layout
end

get "/new_flight" do
  erb :form, layout: :layout
end

get "/:flight" do
  @flight_name = params[:flight].to_sym

  @flights.each_with_index do |ele, index|
    ele.each_pair do |k, _|
      if k == @flight_name
        @airline = @flights[index][k][:airline]
        @flight_number = @flights[index][k][:flight_number]
        @destination = @flights[index][k][:airline]
        @departure_time = @flights[index][k][:departure_time]
      end
    end
  end

  erb :one_flight, layout: :layout
end

post "/save_flight" do
  user_flight_name = params[:user_given_flight_name]

  if !(1..20).cover?(user_flight_name.size)
    session[:error] = "flight needs a name"
    erb :form, layout: :layout
  else
    airline = params[:airline]
    flight_num = params[:flight_number]
    depart_time = params[:departure_time]
    destination = params[:destination]

    new_flight = {
      user_flight_name.to_sym => {
        "airline".to_sym => airline,
        "flight_number".to_sym => flight_num,
        "destination".to_sym => destination,
        "departure_time".to_sym => depart_time
      }
    }

    File.open("flights.yaml", "a+") do |f|
      f << new_flight.to_yaml(Separator: false)
    end

    redirect "/flights"
  end
end
