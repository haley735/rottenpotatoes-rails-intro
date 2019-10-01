class Movie < ActiveRecord::Base
    def self.all_ratings
	self.fine(:all, :select => "rating", :group => "rating").map(&:rating)
    end

  attr_accessor :title, :rating, :description, :release_date, :director

  def self.get_possible_ratings
	return %w[G PG PG-13 R]
  end


end
