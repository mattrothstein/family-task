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

#######################
####### USERS #########
#######################

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

get "/users/:id/edit" do
  @user = User.find(params[:id])
  erb :'users/edit'
end

put "/users/:id" do
  @user = User.find(params[:id])
  params.delete(:_method)
  if @user.update(params)
    redirect '/users'
  else
    erb :'users/edit'
  end
end

delete "/users/:id" do
  @user = User.find(params[:id])
  @user.destroy
  redirect '/users'
end


#######################
####### TASKS #########
#######################

get "/tasks" do
  @tasks = Task.all
  erb :'tasks/index'
end

get "/tasks/new" do
  @task = Task.new
  erb :'tasks/new'
end

post "/tasks" do
  id = Task.maximum(:id)&.next || 1
  params.merge!({ id: id, status: false })
  @task = Task.new(params)

  if @task.save
    redirect '/tasks'
  else
    erb :'tasks/new'
  end
end

get "/tasks/:id/edit" do
  @task = Task.find(params[:id])
  erb :'tasks/edit'
end

put "/tasks/:id" do
  @task = Task.find(params[:id])
  params.delete(:_method)
  if @task.update(params)
    redirect '/tasks'
  else
    erb :'tasks/edit'
  end
end

delete "/tasks/:id" do
  @task = Task.find(params[:id])
  @task.destroy
  redirect '/tasks'
end

#######################
##### LOCATIONS #######
#######################

get "/locations" do
  @locations = Location.all
  erb :'locations/index'
end

get "/locations/new" do
  @location = Location.new
  erb :'locations/new'
end

post "/locations" do
  params.merge!({ id: Location.maximum(:id).next })
  @location = Location.new(params)

  if @location.save
    redirect '/locations'
  else
    erb :'locations/new'
  end
end

get "/locations/:id/edit" do
  @location = Location.find(params[:id])
  erb :'locations/edit'
end

put "/locations/:id" do
  @location = Location.find(params[:id])
  params.delete(:_method)
  if @location.update(params)
    redirect '/users'
  else
    erb :'locations/edit'
  end
end

delete "/locations/:id" do
  @location = Location.find(params[:id])
  @location.destroy
  redirect '/locations'
end


