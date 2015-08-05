class PlaylistEditor < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable
  include Authority::UserAbilities
end
