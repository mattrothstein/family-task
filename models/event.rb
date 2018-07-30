require 'sinatra/activerecord'

class Event < ActiveRecord::Base
  belongs_to :location
  has_many :tasks, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :hosts, dependent: :destroy
  validates :date, :location_id, :id, :title, presence: true

  def self.search(search)
    collection = self.all
    collection = collection.where(location_id: search[:location_id]) if search[:location_id].present?
    collection = collection.where("title ilike :title", title: "#{search[:title]}%") if search[:title].present?
    collection
  end
end
