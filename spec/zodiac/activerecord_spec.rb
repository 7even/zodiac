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
      dob          = Time.gm(1955, 2, 24)
      @person      = Person.create(:name => 'Steve', :dob => dob)
      @lite_person = LitePerson.create(:name => 'Steve lite', :dob => dob)
    end
    
    describe "#zodiac_sign" do
      context "on a migrated model" do
        it "returns a correct zodiac sign based on date_for_zodiac attribute" do
          @person.zodiac_sign.should == I18n.t('zodiac.pisces')
        end
      end
      
      context "on a non-migrated model" do
        it "returns a correct zodiac sign based on date_for_zodiac attribute" do
          @lite_person.zodiac_sign.should == I18n.t('zodiac.pisces')
        end
      end
    end
    
    describe "before_save callback" do
      before(:each) do
        @new_dob = Time.gm(1955, 10, 28)
      end
      
      context "on a migrated model" do
        it "updates the zodiac_sign_id attribute" do
          @person.update_attribute(:dob, @new_dob)
          @person.zodiac_sign_id.should == 8
        end
      end
      
      context "on a non-migrated model" do
        it "doesn't break saving" do
          @lite_person.update_attribute(:dob, @new_dob)
          @lite_person.reload.dob.should == @new_dob
        end
      end
    end
    
    after(:all) do
      Person.delete_all
      LitePerson.delete_all
    end
  end
end
