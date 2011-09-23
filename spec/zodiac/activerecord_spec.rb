require 'spec_helper'

describe Zodiac::ActiveRecord do
  describe "class methods" do
    describe ".zodiac_reader" do
      it "sets @date_for_zodiac with the given value" do
        Person.date_for_zodiac.should == :dob
      end
    end
  end
  
  describe "instance_methods" do
    before(:each) do
      dob = Time.gm(1955, 2, 24)
      @person = Person.create(:name => 'Steve', :dob => dob)
    end
    
    describe "#zodiac_sign" do
      it "returns a correct zodiac sign based on date_for_zodiac attribute" do
        @person.zodiac_sign.should == I18n.t('zodiac.pisces')
      end
    end
    
    describe "before_save callback" do
      it "updates the zodiac_sign_id attribute" do
        new_dob = Time.gm(1955, 10, 28)
        @person.update_attribute(:dob, new_dob)
        @person.zodiac_sign_id.should == 8
      end
    end
    
    after(:all) do
      Person.delete_all
    end
  end
end
