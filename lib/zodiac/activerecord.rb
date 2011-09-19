module Zodiac
  module ActiveRecord
    module InstanceMethods
      def zodiac_sign
        raise 'You should call #zodiac_reader in your class for this to work' unless self.class.respond_to?(:date_for_zodiac)
        
        date_method = self.class.date_for_zodiac
        self.send(date_method).try(:zodiac_sign)
      end
    end
    
    module ClassMethods
      attr_reader :date_for_zodiac
      
      def zodiac_reader(dob_attribute)
        @date_for_zodiac = dob_attribute
      end
    end
    
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end
  end
end

if defined?(::ActiveRecord)
  ActiveRecord::Base.send(:include, Zodiac::ActiveRecord)
end
