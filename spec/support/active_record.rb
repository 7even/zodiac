require 'active_record'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Migration.create_table :lite_people do |t|
  t.string  :name
  t.date    :dob
  
  t.timestamps
end

ActiveRecord::Migration.create_table :people do |t|
  t.string  :name
  t.date    :dob
  t.integer :zodiac_sign_id
  
  t.timestamps
end

ActiveRecord::Migration.create_table :custom_people do |t|
  t.string  :name
  t.date    :dob
  t.integer :custom_sign_id
  
  t.timestamps
end
