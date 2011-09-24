module Zodiac
  class MigrationGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :model_name, :type => :string
    argument :sign_attribute, :type => :string, :default => 'zodiac_sign_id'
    
    def copy_files
      template template_name, "db/migrate/#{migration_filename}.rb"
    end
  private
    def template_name
      if Rails.version < '3.1'
        'migration30.rb.erb'
      else
        'migration31.rb.erb'
      end
    end
    
    def date_prefix
      Time.now.strftime('%Y%m%d%H%M%S') # filename prefix like 20110922205139
    end
    
    def migration_filename
      "#{date_prefix}_add_#{sign_attribute}_to_#{table_name}"
    end
    
    def migration_classname
      "Add#{sign_attribute.camelcase}To#{model_name.gsub('::', '').camelcase.pluralize}"
    end
    
    def model_classname
      model_name.camelcase.singularize
    end
    
    def table_name
      model_name.underscore.gsub('/', '_').pluralize
    end
  end
end
