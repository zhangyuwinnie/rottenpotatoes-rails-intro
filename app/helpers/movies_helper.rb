module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  
  def was_checked?(rating)
  	@checked_ratings.include? rating unless !@checked_ratings
  end
  

end
