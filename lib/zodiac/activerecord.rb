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
        
        # if the migration was applied, we should update the sign attribute before each save
        if self.column_names.include?('zodiac_sign_id')
          self.before_save do |object|
            object.zodiac_sign_id = object.send(dob_attribute).try(:zodiac_sign_id)
          end
        end
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
