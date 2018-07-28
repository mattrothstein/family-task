require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'tilt/erubis'
require 'pry'

configure :development do
  set :database, {adapter: 'postgresql', database: 'familytask'}
end

current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

get "/" do
  erb :home
end

get "/users" do
  @users = User.all
  erb :'users/index'
end

get "/users/new" do
  @user = User.new
  erb :'users/new'
end

post "/users" do
  params.merge!({ id: User.maximum(:id).next })
  @user = User.new(params)

  if @user.save
    redirect '/users'
  else
    erb :'users/new'
  end
end
