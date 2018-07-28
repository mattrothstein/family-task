require 'sinatra/activerecord'

class Task < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  validates :description, :user_id, :id, presence: true
end
