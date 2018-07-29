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
  params.merge!({ id: (User.maximum(:id)&.next || 1)})
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
  params.merge!({ id: (Location.maximum(:id)&.next || 1)})
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
    redirect '/locations'
  else
    erb :'locations/edit'
  end
end

delete "/locations/:id" do
  @location = Location.find(params[:id])
  @location.destroy
  redirect '/locations'
end


#######################
####### EVENTS ########
#######################

get "/events" do
  @events = Event.all
  erb :'events/index'
end

get "/events/new" do
  @event = Event.new
  erb :'events/new'
end

post "/events" do
  id = Event.maximum(:id)&.next || 1
  params.merge!({ id: id })
  event_params    = params.slice(:id, :date, :location_id, :description, :title)
  @event          = Event.new(event_params)

  if @event.save
    redirect '/events'
  else
    erb :'events/new'
  end
end

get "/events/:id/edit" do
  @event = Event.find(params[:id])
  erb :'events/edit'
end

put "/events/:id" do
  @event = Event.find(params[:id])
  params.delete(:_method)
  if @event.update(params)
    redirect '/events'
  else
    erb :'events/edit'
  end
end

delete "/events/:id" do
  @event = Event.find(params[:id])
  @event.destroy
  redirect '/events'
end

#######################
####### HOSTS #########
#######################

get "/event/:event_id/hosts" do
  @event = Event.find(params[:event_id])
  @hosts = @event.hosts

  erb :'hosts/index'
end

get "/event/:event_id/hosts/new" do
  @event = Event.find(params[:event_id])
  @host  = @event.hosts.new()
  erb :'hosts/new'
end

post "/event/:event_id/hosts" do
  @event = Event.find(params[:event_id])
  @host  = @event.hosts.new(user_id: params[:user_id])

  begin
    if @host.save
      redirect "event/#{params[:event_id]}/hosts"
    else
      erb :'hosts/new'
    end
  rescue ActiveRecord::RecordNotUnique
    @host.errors.add(:base, "User is already hosting this event")
    erb :'hosts/new'
  end
end

delete "/event/:event_id/hosts/:user_id" do
  @host = Host.find_by(event_id: params[:event_id], user_id: params[:user_id])
  sql = "delete from hosts where hosts.user_id = #{@host.user_id} and hosts.event_id = #{@host.event_id};"
  ActiveRecord::Base.connection.execute(sql)

  redirect "event/#{params[:event_id]}/hosts"
end

#######################
##### ATTENDEES #######
#######################

get "/event/:event_id/attendees" do
  @event     = Event.find(params[:event_id])
  @attendees = @event.attendees

  erb :'attendees/index'
end

get "/event/:event_id/attendees/new" do
  @event     = Event.find(params[:event_id])
  @attendee  = @event.hosts.new()
  erb :'attendees/new'
end

post "/event/:event_id/attendees" do
  @event     = Event.find(params[:event_id])
  @attendee  = @event.attendees.new(user_id: params[:user_id])

  begin
    if @attendee.save
      redirect "event/#{params[:event_id]}/attendees"
    else
      erb :'attendees/new'
    end
  rescue ActiveRecord::RecordNotUnique
    @attendee.errors.add(:base, "User is already attending this event")
    erb :'attendees/new'
  end
end

delete "/event/:event_id/attendees/:user_id" do
  @attendee = Attendee.find_by(event_id: params[:event_id], user_id: params[:user_id])
  sql = "delete from attendees where attendees.user_id = #{@attendee.user_id} and attendees.event_id = #{@attendee.event_id};"
  ActiveRecord::Base.connection.execute(sql)

  redirect "event/#{params[:event_id]}/attendees"
end


#######################
####### STATS #########
#######################

# 1. Completed Tasks for a User
# 2. Completed Tasks for an Event
# 3. Events For a Location
# 4. Hosted Events for a User
# 5. All Attendees of an Event
# 6. Users who have attended the most events
# 7. Users who have hosted the most events

get "/stats" do
  @completed_tasks_by_user = User.select("users.id, users.first_name, COUNT(tasks.id) completed_task_count").
                                  joins(:tasks).
                                  where("tasks.status = ?", true).
                                  group("users.id").
                                  order("completed_task_count DESC")

  @completed_tasks_by_event = Event.select("events.id, events.title, COUNT(tasks.id) completed_task_count").
                                  joins(:tasks).
                                  where("tasks.status = ?", true).
                                  group("events.id").
                                  order("completed_task_count DESC")

  @events_count_by_location = Location.select("locations.id, locations.address_1, COUNT(events.id) events_hosted_count").
                                  joins(:events).
                                  group("locations.id").
                                  order("events_hosted_count DESC")

  @host_by_user             = User.select("users.id, users.first_name, COUNT(hosts.event_id) events_hosted_count").
                                  joins(:hosts).
                                  group("users.id").
                                  order("events_hosted_count DESC")

  @attended_by_user         = User.select("users.id, users.first_name, COUNT(attendees.event_id) events_attended_count").
                                  joins(:attendees).
                                  group("users.id").
                                  order("events_attended_count DESC")
  erb :stats
end
