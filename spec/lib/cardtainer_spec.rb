require 'spec_helper'

describe Cardtainer do
  let(:cardtainer) { Cardtainer.new }
  it "inherits from Array" do
    expect(Cardtainer.superclass).to be(Array)
  end
  describe '.new' do
    it "initializes" do
      expect(cardtainer).to be_an_instance_of(Cardtainer)
    end
    it "does not accept arguments" do
      expect{Cardtainer.new(4)}.to raise_error(ArgumentError)
    end
  end

  describe '.convert' do
    context "when passed anything but an Array or Cardtainer" do
      it "returns nil" do
        ["String", :Symbol, 42].each do |obj|
          expect(Cardtainer.convert(obj)).to be_nil
        end
      end
    end
    context "when passed a Cardtainer" do
      it "returns the cardtainer" do
        expect(Cardtainer.convert(cardtainer)).to be(cardtainer)
      end
    end
    context "when passed an Array" do
      context "when containing only Cards" do
        let!(:array) { Array.new(10) { Card.new(:joker) } }
        let(:cardtainer) { Cardtainer.convert(array) }
        it "converts the Array to a Cardtainer" do
          expect(cardtainer).to be_an_instance_of(Cardtainer)
          array.zip(cardtainer).each do |pair|
            expect(pair.first.equal? pair.last).to be(true)
          end
        end
      end
      context "when passed an Array with non-Card elements" do
        let!(:array) { Array.new(10) { Card.new(:joker) }.push(:not_a_card) }
        let(:cardtainer) { Cardtainer.convert(array) }
        it "does not add non-Card elements to the Cardtainer" do
          cardtainer.each { |c| expect(c.instance_of?(Card)).to be(true) }
        end
      end
    end
  end

  describe 'undefined methods' do
    it "raises error" do
      expect{Cardtainer.try_convert}.to raise_error(NoMethodError)
      expect{Cardtainer.[]}.to raise_error(NoMethodError)
    end
  end







end
