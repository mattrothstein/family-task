require 'sinatra/activerecord'
require 'pry'

class User < ActiveRecord::Base
  has_many :hosts
  has_many :attendees
  has_many :tasks, dependent: :destroy

  has_many :events, through: :hosts
  has_many :events, through: :attendees

  validates :first_name, :last_name, :email, :password, :id, presence: true

  before_destroy :delete_host_and_attendees

  def delete_host_and_attendees
    host_sql = "delete from hosts where hosts.user_id = #{self.id};"
    ActiveRecord::Base.connection.execute(host_sql)
    attendee_sql = "delete from attendees where attendees.user_id = #{self.id};"
    ActiveRecord::Base.connection.execute(attendee_sql)
  end
end
