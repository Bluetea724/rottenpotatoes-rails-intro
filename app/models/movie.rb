class Movie < ActiveRecord::Base
	
	items = Array[]
	
	@Movie_rate= Movie.all.select('rating').distinct
	
	@Movie_rate.each do |movie|
		items<<movie.rating		
	end
end
