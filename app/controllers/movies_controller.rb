class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_possible_ratings

    unless params[:ratings].nil?
      @filtered_ratings = params[:ratings]
      session[:filtered_ratings] = @filtered_ratings
    end

    if params[:sorting_mechanism].nil?
    else
      session[:sorting_mechanism] = params[:sorting_mechanism]
    end

    if params[:sorting_mechanism].nil? && params[:ratings].nil? && session[:filtered_ratings]
      @filtered_ratings = session[:filtered_ratings]
      @sorting_mechanism = session[:sorting_mechanism]
      flash.keep
      redirect_to movies_path({order_by: @sorting_mechanism, ratings: @filtered_ratings})
    end

    @movies = Movie.all

    if session[:filtered_ratings]
      @movies = @movies.select{ |movie| session[:filtered_ratings].include? movie.rating }
    end

    if session[:sorting_mechanism] == "title"
      @movies = @movies.sort! { |a,b| a.title <=> b.title }
      @movie_highlight = "hilite"
    elsif session[:sorting_mechanism] == "release_date"
      @movies = @movies.sort! { |a,b| a.release_date <=> b.release_date }
      @date_highlight = "hilite"
    else
      
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def find_with_same_director
    @movie = Movie.find(params[:id])
    @current_movie_director = @movie.director
    if @current_movie_director.nil? or @current_movie_director.empty?
      flash[:warning] = "'#{@movie.title}' has no director info."
      redirect_to movies_path
    else
      @movies_to_render = Movie.find_all_by_director(@current_movie_director)
    end
  end

end
