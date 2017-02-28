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
    
    session[:sort] = params[:sort] if params[:sort]
    session[:ratings] = params[:ratings] if params[:ratings]
 
    if (session[:sort] == "title")
      sortby = :title
    elsif (session[:sort] = "release_date")
      sortby = :release_date
    end

    if (params[:sort] and !session[:ratings])
      @movies = Movie.all.order(sortby)
    elsif (params[:sort] and session[:ratings])
      check_box = session[:ratings].collect{|id| id}
      mark = []
      check_box.each do |i|
        mark << i[0]
      end
      @movies = Movie.where(:rating => mark).order(sortby)
    elsif (!params[:sort] and params[:ratings])
      check_box = session[:ratings].collect{|id| id}
      mark = []
      check_box.each do |i|
        mark << i[0]
      end
      @movies = Movie.where(:rating => mark)
    elsif (!session[:sort] and !session[:rating])
      @movies = Movie.all
    elsif session[:ratings] != params[:ratings] || session[:sort] != params[:sort]
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
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
