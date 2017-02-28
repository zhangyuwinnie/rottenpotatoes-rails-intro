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
    # for rating filtering
    @all_ratings = Movie.select(:rating).all.uniq
    
    
    @filtered_ratings = params[:ratings] ? params[:ratings].keys : @all_ratings
    
    # sort by title and releaes_date
    if (params[:sort] == "title")
      @movies = Movie.order(:title).all
    elsif (params[:sort] == "release_date")
      @movies = Movie.order(:release_date).all
    elsif (params[:sort] == nil and params[:ratings])
      check_box = params[:ratings].collect{|id| id}
      mark = []
      check_box.each do |i|
        mark << i[0]
      end
      @movies = Movie.where(:rating => mark)
    else
      @movies = Movie.all
    end
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
