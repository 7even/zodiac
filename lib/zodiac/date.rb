module Zodiac
  module Date
    def zodiac_sign
      raise "#{self} should respond_to #month and #day" unless respond_to?(:month) && respond_to?(:day)
      Finder.sign_for(:month => self.month, :day => self.day)
    end
    
    def zodiac_sign_id
      raise "#{self} should respond_to #month and #day" unless respond_to?(:month) && respond_to?(:day)
      Finder.sign_id_for(:month => self.month, :day => self.day)
    end
  end
end

[Time, Date, DateTime].each do |date_class|
  date_class.send(:include, Zodiac::Date) 
end
