class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.uniq.pluck(:rating) 
    
    #Getting ratings info
    @ratings_filter = params[:ratings]
    
    if @Ratings_filter == nil
      if session[:ratings] != nil
        params[:ratings] = session[:ratings]
        redirect_to movies_path(params)
      end
    else
      @Ratings_filter = params[:ratings].keys
    end
    
    @movies = @movies.where(:rating => @ratings_filter)
    
    #Getting sort info
    @sorting_filter = params[:sort]
    
    if @sorting_filter == nil
      if session[:sort] != nil
        params[:sort] = session[:sort]
        redirect_to movies_path(params)
      end
    end
    
    @movies = @movies.order(@sorting_filter)
    
    session[:sort] = @sorting_filter
    session[:ratings] = @rating_filter

  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
