require 'sinatra/activerecord'

class Location < ActiveRecord::Base
  has_many :events, dependent: :destroy
  validates :address_1, :address_2, :city, :id, :state, :postal_code, presence: true
  validates :postal_code, numericality: true

  def self.search(search)
    collection = self.all
    collection = collection.where("address_1 ilike :address_1", address_1: "#{search[:address_1]}%") if search[:address_1].present?
    collection = collection.where("address_2 ilike :address_2", address_2: "#{search[:address_2]}%") if search[:address_2].present?
    collection = collection.where("city ilike :city", city: "#{search[:city]}%") if search[:city].present?
    collection = collection.where("state ilike :state", state: "#{search[:state]}%") if search[:state].present?
    collection = collection.where(postal_code: search[:postal_code]) if search[:postal_code].present?
    collection
  end
end
