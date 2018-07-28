require 'sinatra/activerecord'

class Location < ActiveRecord::Base
  has_many :events, dependent: :destroy
  validates :address_1, :address_2, :city, :id, :state, :postal_code, presence: true
  validates :postal_code, numericality: true
end
