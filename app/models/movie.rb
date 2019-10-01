class Movie < ActiveRecord::Base
    def self.all_ratings
	self.fine(:all, :select => "rating", :group => "rating").map(&:rating)
    end
end
