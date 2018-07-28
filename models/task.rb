require 'sinatra/activerecord'

class Task < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :event, class_name: "Event"
  validates :description, :user_id, :id, presence: true
end
