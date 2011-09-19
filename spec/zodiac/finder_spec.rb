require 'spec_helper'

describe Zodiac::Finder do
  describe ".date_for" do
    it "generates correct dates" do
      subject.date_for(9, 27).should == DateTime.new(subject::YEAR, 9, 27)
    end
  end
  
  describe ".sign_for" do
    it "returns correct zodiac sign" do
      subject.sign_for(:month => 9, :day => 27).should == I18n.t('zodiac.libra')
    end
  end
end
