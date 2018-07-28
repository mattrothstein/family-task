require 'sinatra/activerecord'

class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, :password, :id, presence: true
end
