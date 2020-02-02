module Zodiac
  module ActiveRecord
    module InstanceMethods
      def zodiac_sign
        raise 'You should call #zodiac_reader in your class for this to work' unless self.class.respond_to?(:date_for_zodiac)
        self.send(self.class.date_for_zodiac).try(:zodiac_sign)
      end
      
      Zodiac.each_sign do |symbol, integer|
        method_name = "#{symbol}?"
        define_method(method_name) do
          raise 'You should call #zodiac_reader in your class for this to work' unless self.class.respond_to?(:date_for_zodiac)
          self.send(self.class.date_for_zodiac).try(method_name)
        end
      end
      
    private
      def update_sign_id
        sign_id_method  = "#{self.class.zodiac_sign_id_field}="
        new_sign_id     = self.send(self.class.date_for_zodiac).try(:zodiac_sign_id)
        self.send(sign_id_method, new_sign_id)
      end
    end
    
    module ClassMethods
      attr_reader :date_for_zodiac, :zodiac_sign_id_field
      
      def zodiac_reader(dob_attribute, options = { sign_id_attribute: :zodiac_sign_id })
        @date_for_zodiac = dob_attribute
        @zodiac_sign_id_field = options[:sign_id_attribute]
        
        # if the migration was applied, we should update the sign attribute before each save
        # and define some scopes
        if self.connection.table_exists?(self.table_name) && self.column_names.include?(@zodiac_sign_id_field.to_s)
          self.before_save do |object|
            object.send(:update_sign_id)
          end
          
          # Person.by_zodiac(7 || :libra) == Person.where(zodiac_sign_id: 7)
          scope :by_zodiac, ->(sign) do
            case sign
            when Symbol
              where(self.zodiac_sign_id_field => Zodiac::Finder::SIGN_IDS[sign])
            when Fixnum
              where(self.zodiac_sign_id_field => sign)
            else
              raise ArgumentError, "Invalid attribute type #{sign.class} for #{self}.by_zodiac"
            end
          end
          
          # Person.gemini == Person.by_zodiac(3)
          Zodiac.each_sign do |symbol, integer|
            scope symbol, -> { by_zodiac(integer) }
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
