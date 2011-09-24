require 'spec_helper'

module Zodiac
  describe Date do
    %w(Time Date DateTime).each do |date_class|
      context "included into #{date_class}" do
        before(:each) do
          @date = Object.const_get(date_class).new(Finder::YEAR, 9, 27)
        end
        
        it 'provides #zodiac_sign' do
          @date.zodiac_sign.should == I18n.t('zodiac.libra')
        end
        
        it "provides #zodiac_sign_id" do
          @date.zodiac_sign_id.should == 7
        end
        
        Zodiac.each_sign do |symbol, integer|
          method_name = "#{symbol}?"
          it "provides ##{method_name}" do
            @date.should respond_to(method_name)
          end
        end
        
        context "predicate methods (like #libra?)" do
          it "return true if the sign is correct" do
            @date.should be_libra
          end
          
          it "return false if the sign is incorrect" do
            @date.should_not be_gemini
          end
        end
      end
    end
  end
end
