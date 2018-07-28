require 'sinatra/activerecord'

class Event < ActiveRecord::Base
  belongs_to :location
  has_many :tasks, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :hosts, dependent: :destroy
  validates :date, :location_id, :id, :title, presence: true
end
