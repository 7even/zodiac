require 'spec_helper'

describe Zodiac do
  it "generates corect dates" do
    Zodiac.date_for(9, 27).should == DateTime.new(Zodiac::YEAR, 9, 27)
  end
  
  it "returns correct zodiac sign" do
    Zodiac.sign_for(:month => 9, :day => 27).should == :libra
  end
end