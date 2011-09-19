module Zodiac
  module Finder
    YEAR = 2011
    
    class << self
      def date_for(month, day)
        DateTime.new(YEAR, month, day)
      end
      
      def range_for(month_start, day_start, month_end, day_end)
        start, ending = date_for(month_start, day_start), date_for(month_end, day_end)
        SimpleRange.new(start, ending)
      end
    end
    
    RANGES = {
      :capricorn    => range_for(1,  1,  1,  20),
      :aquarius     => range_for(1,  21, 2,  19),
      :pisces       => range_for(2,  20, 3,  20),
      :aries        => range_for(3,  21, 4,  20),
      :taurus       => range_for(4,  21, 5,  21),
      :gemini       => range_for(5,  22, 6,  21),
      :cancer       => range_for(6,  22, 7,  22),
      :leo          => range_for(7,  23, 8,  21),
      :virgo        => range_for(8,  22, 9,  23),
      :libra        => range_for(9,  24, 10, 23),
      :scorpio      => range_for(10, 24, 11, 22),
      :sagittarius  => range_for(11, 23, 12, 22),
      :capricorn    => range_for(12, 23, 12, 31)
    }
    
    def self.sign_for(date)
      RANGES.each do |sign, range|
        if range.days.include? date_for(date[:month], date[:day])
          return I18n.t!("zodiac.#{sign}")
        end
      end
      
      raise ArgumentError
    end
  end
end
