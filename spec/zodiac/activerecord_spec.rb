require 'spec_helper'

describe Zodiac::ActiveRecord do
  describe "class methods" do
    context "standard model" do
      before(:each) do
        @gemini1 = Person.create dob: Time.gm(1982, 5, 27)
        @gemini2 = Person.create dob: Time.gm(1987, 5, 29)
        @libra   = Person.create dob: Time.gm(1984, 9, 27)
        @nobody  = Person.create dob: nil
      end
      
      describe ".zodiac_reader" do
        it "sets @date_for_zodiac with the given value" do
          Person.date_for_zodiac.should == :dob
        end
      end
      
      describe ".by_zodiac" do
        context "with an integer argument" do
          it "returns a scope with objects belonging to a given sign" do
            gemini = Person.by_zodiac(3)
            gemini.should include(@gemini1)
            gemini.should include(@gemini2)
            gemini.should_not include(@libra)
            gemini.should_not include(@nobody)
          end
        end
        
        context "with a symbol argument" do
          it "returns a scope with objects belonging to a given sign" do
            libra = Person.by_zodiac(:libra)
            libra.should_not include(@gemini1)
            libra.should_not include(@gemini2)
            libra.should include(@libra)
            libra.should_not include(@nobody)
          end
        end
      end
      
      describe "named zodiac scopes (like .libra)" do
        it "call .by_zodiac with a given sign and return its result" do
          Person.libra.should_not include(@gemini1)
          Person.libra.should_not include(@gemini2)
          Person.libra.should include(@libra)
          Person.libra.should_not include(@nobody)
        end
      end  
      
      after(:each) do
        Person.delete_all
      end
    end
    
    context "custom model" do
      before(:each) do
        @gemini1 = CustomPerson.create dob: Time.gm(1982, 5, 27)
        @gemini2 = CustomPerson.create dob: Time.gm(1987, 5, 29)
        @libra   = CustomPerson.create dob: Time.gm(1984, 9, 27)
        @nobody  = CustomPerson.create dob: nil
      end
      
      describe ".zodiac_reader" do
        it "sets @date_for_zodiac with the given value" do
          CustomPerson.date_for_zodiac.should == :dob
        end
        
        it "sets @zodiac_sign_id_field with the given value" do
          CustomPerson.zodiac_sign_id_field.should == :custom_sign_id
        end
      end
      
      describe ".by_zodiac" do
        it "returns a scope with objects belonging to a given sign" do
          gemini = CustomPerson.by_zodiac(3)
          gemini.should include(@gemini1)
          gemini.should include(@gemini2)
          gemini.should_not include(@libra)
          gemini.should_not include(@nobody)
        end
      end
      
      after(:each) do
        CustomPerson.delete_all
      end
    end
  end
  
  describe "instance_methods" do
    before(:each) do
      dob          = Time.gm(1955, 2, 24)
      @person      = Person.create(name: 'Steve', dob: dob)
      @lite_person = LitePerson.create(name: 'Steve lite', dob: dob)
      @nobody      = Person.create(name: 'Nobody', dob: nil)
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
      
      context "on a model with a nil date" do
        it "returns nil" do
          @nobody.zodiac_sign.should be_nil
        end
      end
    end
    
    describe "predicate methods (like #libra?)" do
      context "on a migrated model" do
        it "return true if the sign is correct" do
          @person.should be_pisces
        end
        
        it "return false if the sign is incorrect" do
          @person.should_not be_libra
        end
      end
      
      context "on a non-migrated model" do
        it "return true if the sign is correct" do
          @lite_person.should be_pisces
        end
        
        it "return false if the sign is incorrect" do
          @lite_person.should_not be_libra
        end
      end
      
      context "on a model with a nil date" do
        it "return false" do
          @nobody.should_not be_pisces
          @nobody.should_not be_libra
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
        
        it "sets nil for a nil date" do
          @person.update_attribute(:dob, nil)
          @person.zodiac_sign_id.should be_nil
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
