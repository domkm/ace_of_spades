require 'spec_helper'

describe Suit do
  let(:spades) { Suit.new(:Spades) }

  describe '.new' do
    context "when passed a valid argument" do
      it "initializes" do
        [:Spades, 'spades', :s, 'S'].each do |suit|
          suit = Suit.new(suit)
          expect(suit).to be_an_instance_of(Suit)
        end
      end
    end
    context "when passed an invalid argument" do
      it "raises an error" do
        [:x, :X, "X", "Spaaaaades", 42, 10].each do |suit|
          expect{Suit.new(suit)}.to raise_error
        end
      end
    end
  end

  describe '.suitable?' do
    context "when passed an argument that can be converted to a suit" do
      it "returns true" do
        [:Spades, "Spades", :s].each do |suit|
          expect(Suit.suitable?(suit)).to be(true)
        end
      end
    end
    context "when passed an argument that cannot be converted to a suitue" do
      it "returns false" do
        [:x, "X", 42, 3, "AceOfSpades"].each do |suit|
          expect(Suit.suitable?(suit)).to be(false)
        end
      end
    end
  end

  describe '.wrap' do
    context "when passed a Suit instance" do
      it "returns the Suit instance" do
        expect(Suit.wrap(spades)).to be(spades)
      end
    end
    context "when passed an object that can be converted to a Suit" do
      context "when passed a full String or Symbol" do
        it "returns a Suit" do
          ["Spades", "spades", :Spades, :spades].each do |suit|
            suit = Suit.wrap(suit)
            expect(suit).to be_an_instance_of(Suit)
            expect(suit.instance_variable_get(:@symbol)).to eq(:Spades)
          end
        end
      end
      context "when passed a short String or Symbol" do
        it "returns a Suit" do
          ["S", "s", :S, :s].each do |suit|
            suit = Suit.wrap(suit)
            expect(suit).to be_an_instance_of(Suit)
            expect(suit.instance_variable_get(:@symbol)).to eq(:Spades)
          end
        end
      end
    end
    context "when passed an object that cannot be coerced to a Suit" do
      it "returns nil" do
        ["AceOfSpades", :X, 42, 42.0, 1, true].each do |suit|
          suit = Suit.wrap(suit)
          expect(suit).to be_nil
        end
      end
    end
  end

  describe '.parse' do
    context "when passed an object that can be converted to a Suit Symbol" do
      context "when passed a full String or Symbol" do
        it "returns a Suit Symbol" do
          ["Spades", "spades", :Spades, :spades].each do |suit|
            suit = Suit.parse(suit)
            expect(suit).to eq(:Spades)
          end
        end
      end
      context "when passed a full String or Symbol in singular form" do
        it "returns a Suit Symbol" do
          ["Spade", "spade", :Spade, :spade].each do |suit|
            suit = Suit.parse(suit)
            expect(suit).to eq(:Spades)
          end
        end
      end
      context "when passed a short String or Symbol" do
        it "returns a Suit Symbol" do
          ["S", "s", :S, :s].each do |suit|
            suit = Suit.parse(suit)
            expect(suit).to eq(:Spades)
          end
        end
      end
    end
    context "when passed an object that cannot be coerced to a Suit Symbol" do
      it "returns nil" do
        ["AceOfSpades", :X, 42, 42.0, 1, true].each do |suit|
          suit = Suit.parse(suit)
          expect(suit).to be_nil
        end
      end
    end
  end

  describe '#<=>' do
    let(:spades) { Suit.new(:Spades) }
    let(:clubs) { Suit.new(:Clubs) }
    context "when passed an argument that cannot be compared to a Suit" do
      it "returns nil" do
        expect(spades <=> 5).to be_nil
      end
    end
    context "when passed an argument that is a Suit" do
      context "when passed a Suit that is greater than receiver" do
        it "returns -1" do
          expect(clubs <=> spades).to be(-1)
        end
      end
      context "when passed a Suit that is less than receiver" do
        it "returns 1" do
          expect(spades <=> clubs).to be(1)
        end
      end
      context "when passed a Suit that is equal to receiver" do
        it "returns 0" do
          expect(spades <=> spades).to be(0)
        end
      end
    end
  end

  describe '#to_sym' do
    it "returns the Suit as a Symbol" do
      expect(spades.to_sym).to eq(:Spades)
    end
  end

  describe '#to_s' do
    it "returns the Suit as a String" do
      expect(spades.to_s).to eq('Spades')
    end
  end

  describe '#to_str' do
    it "returns the Suit as a String" do
      expect(spades.to_str).to eq('Spades')
    end
  end

  describe '#card & #card=' do
    it "assigns/retrieves the card" do
      expect(spades.card).to be_nil
      spades.card = :Foo
      expect(spades.card).to be(:Foo)
    end
  end

  describe '#method_missing' do
    context "when a valid predicate method is called" do
      context "when the method called should return true" do
        it "returns true" do
          expect(spades.spades?).to be(true)
        end
        context "when passed a singular suit" do
          it "returns true" do
            expect(spades.spade?).to be(true)
          end
        end
      end
      context "when the method called should return false" do
        it "returns false" do
          expect(spades.clubs?).to be(false)
        end
      end
    end
    context "when an invalid predicate method is called" do
      it "raises NoMethodError" do
        expect{spades.not_a_method?}.to raise_error(NoMethodError)
      end
    end
    context "when an invalid method is called" do
      it "raises NoMethodError" do
        expect{spades.not_a_method}.to raise_error(NoMethodError)
      end
    end
  end
end
