class Movie < ActiveRecord::Base
    
	def self.ratings
		ratings = {}
		Movie.select(:rating).distinct.each {|m| ratings[m.rating] = true}
		return ratings
	end
end