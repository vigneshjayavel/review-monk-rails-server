class User < ActiveRecord::Base
  attr_accessible :description, :email, :gps_latitude, :gps_longitude, :name, :work_place, :language, :native_location

  belongs_to :device, :class_name => 'Gcm::Device'

  has_many :user_products
  has_many :products, :source => :product, :through => :user_products

end
