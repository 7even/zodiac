module Zodiac
  module Mongoid
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
        new_sign_id     = send(self.class.date_for_zodiac).try(:zodiac_sign_id)
        send(sign_id_method, new_sign_id)
      end
    end

    module ClassMethods
      attr_accessor :date_for_zodiac, :zodiac_sign_id_field

      def zodiac_reader(dob_attribute, options = {:sign_id_attribute => :zodiac_sign_id})
        @date_for_zodiac = dob_attribute
        @zodiac_sign_id_field = options[:sign_id_attribute]

        # if the zodiac_sign_id attribute is present, we should update the sign attribute before each save
        # and define some scopes
        columns = self.fields.collect { |field| field[0].to_s }
        if columns.include?(@zodiac_sign_id_field.to_s)
          "registering Zodiac before_save"
          self.before_save do |object|
            object.send(:update_sign_id)
          end

          # Person.by_zodiac(7 || :libra) == Person.where(:zodiac_sign_id => 7)
          scope :by_zodiac, lambda { |sign|
            case sign
            when Symbol
              where(self.zodiac_sign_id_field => Zodiac::Finder::SIGN_IDS[sign])
            when Fixnum
              where(self.zodiac_sign_id_field => sign)
            else
              raise ArgumentError, "Invalid attribute type #{sign.class} for #{self}.by_zodiac"
            end
          }

          # Person.gemini == Person.by_zodiac(3)
          Zodiac.each_sign do |symbol, integer|
            scope symbol, by_zodiac(integer)
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

if defined?(::Mongoid)
  Mongoid::Document.send(:include, Zodiac::Mongoid)
end
