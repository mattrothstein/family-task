require 'sinatra/activerecord'

class Attendee < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :event, class_name: 'Event'
  validates :user_id, :event_id, presence: true
end
