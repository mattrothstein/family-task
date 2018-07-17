current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

get '/users' do
  @users = User.all
  erb :index
end
