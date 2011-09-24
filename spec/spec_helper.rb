# bootstrap ActiveRecord
require 'active_record'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'spec/support/test.sqlite3')

require 'zodiac'
require 'pry'

require File.expand_path('../support/person.rb', __FILE__)
require File.expand_path('../support/lite_person.rb', __FILE__)
require File.expand_path('../support/custom_person.rb', __FILE__)
