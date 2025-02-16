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
    
    if params[:ratings] != nil
      #If there is rating info in params, then extract key info
      @ratings_filter = params[:ratings].keys
      if @ratings_filter!=session[:ratings]
        session[:ratings] = @ratings_filter
      end
    else
      #Or use save data
      if session[:ratings] != nil
        @ratings_filter = session[:ratings]
      else
        @ratings_filter = @all_ratings
      end
    end
    
    @movies = @movies.where(:rating => @ratings_filter)
    
    #Getting sort info
    @sorting_filter = params[:sort] 
    
    if @sorting_filter == nil
      if session[:sort] != nil
        params[:sort] = session[:sort]
        return redirect_to params: params
      end
    else
      session[:sort] = @sorting_filter
    end

    @movies = @movies.order(@sorting_filter)
    
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
