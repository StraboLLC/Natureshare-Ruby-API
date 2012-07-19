class Capture < ActiveRecord::Base
  attr_accessible :description, :encoding_finished, :heading, :latitude, :longitude, :media_type, :mp4_finished, :orientation, :taken_at, :title, :token, :webm_finished
end
