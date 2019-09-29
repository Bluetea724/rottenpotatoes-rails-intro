class Movie < ActiveRecord::Base
	def self.all_ratings
		items = Array[]
		
		@Movie_rate= Movie.all.select('rating').distinct
		
		@Movie_rate.each do |movie|
			items<<movie.rating		
		end
	end
end
