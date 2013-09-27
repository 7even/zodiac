require 'spec_helper'

describe Zodiac::Finder do
  describe ".date_for" do
    it "generates correct dates" do
      subject.date_for(9, 27).should == DateTime.new(subject::YEAR, 9, 27)
    end

    it "generates correct dates even in leap year" do
      subject.date_for(2, 29).should == DateTime.new(2012, 2, 29)
    end
  end
  
  describe ".sign_for" do
    it "returns correct zodiac sign" do
      subject.sign_for(:month => 9, :day => 27).should == I18n.t('zodiac.libra')
    end
  end
  
  describe ".sign_id_for" do
    it "returns correct sign id" do
      subject.sign_id_for(:month => 9, :day => 27).should == 7
    end
  end

  describe ".sign_symbol_for" do
    it "returns correct sign symbol" do
      subject.sign_symbol_for(:month => 9, :day => 27).should == :libra
    end
  end
end
