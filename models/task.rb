require 'sinatra/activerecord'

class Task < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :event, class_name: "Event"
  validates :description, :user_id, :id, presence: true

  def self.search(search)
    collection = self.all
    collection = collection.where(event_id: search[:event_id]) if search[:event_id].present?
    collection = collection.where(user_id: search[:user_id]) if search[:user_id].present?
    collection = collection.where(status: true) if search[:status].present?
    collection
  end
end
