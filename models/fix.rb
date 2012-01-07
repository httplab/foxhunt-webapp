class Fix < ActiveRecord::Base
  belongs_to :user
  belongs_to :device
  belongs_to :provider
end