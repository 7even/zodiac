require 'spec_helper'

module Zodiac
  describe Finder do
    it "generates corect dates" do
      Finder.date_for(9, 27).should == DateTime.new(Finder::YEAR, 9, 27)
    end
    
    it "returns correct zodiac sign" do
      Finder.sign_for(:month => 9, :day => 27).should == I18n.t('zodiac.libra')
    end
  end
end
