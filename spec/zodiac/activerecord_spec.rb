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
      @person = Person.new(:name => 'Steve', :dob => dob)
    end
    
    describe "#zodiac_sign" do
      it "returns a correct zodiac sign based on date_for_zodiac attribute" do
        @person.zodiac_sign.should == I18n.t('zodiac.pisces')
      end
    end
  end
end
