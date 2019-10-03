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
    @all_ratings = Movie.all_ratings
    @order_by = params[:sort] # get the sort key
    
    # Determine whether filtering and how
    @all_ratings = Movie.all_ratings
    @filter_ratings = params[:ratings] || session[:ratings] || {}
    # If no filter specified specify all (create hash similar to what is passed in)
    if @filter_ratings == {}
      @filter_ratings = Hash[@all_ratings.map {|rating| [rating, 1]}]
    end
    
    # If either sorting or filtering spec has changed save both and redirect
    if params[:ratings] != session[:ratings]
      
      session[:ratings] = @filter_ratings
      redirect_to :ratings => @filter_ratings and return
    end
    
    # Filter movies by rating 
    @movies = Movie.where(rating: @filter_ratings.keys)
    
    if @order_by == nil
      if session[:sort] != nil
        params[:sort] = session[:sort]
        return redirect_to params: params
      end
    else
      session[:sort] = @order_by
    end

    @movies = @movies.order(@order_by)
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
