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
      end
    end
  end
end
