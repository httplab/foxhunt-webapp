class User < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :fixes
  has_many :devices, :through => :fixes
end