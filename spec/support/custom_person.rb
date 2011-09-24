class CustomPerson < ActiveRecord::Base
  zodiac_reader :dob, :sign_id_attribute => :custom_sign_id
end
