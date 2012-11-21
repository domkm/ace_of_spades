require 'spec_helper'

describe Value do
  let(:ace) { Value.new(:Ace) }

  describe '.new' do
    context "when passed a valid argument" do
      it "initializes" do
        [:Ace, :a, 'Ace', 'A', 1].each do |val|
          value = Value.new(val)
          expect(value).to be_an_instance_of(Value)
        end
      end
    end
    context "when passed an invalid argument" do
      it "raises an error" do
        [:x, :X, "X", "AceOfSpades", 42].each do |val|
          expect{Value.new(val)}.to raise_error
        end
      end
    end
  end

  describe '.valuable?' do
    context "when passed an argument that can be converted to a Value" do
      it "returns true" do
        [:Ace, "Ace", "a", :A, 1, 14].each do |val|
          expect(Value.valuable?(val)).to be(true)
        end
      end
    end
    context "when passed an argument that cannot be converted to a Value" do
      it "returns false" do
        [:x, "X", 42, "AceOfSpades"].each do |val|
          expect(Value.valuable?(val)).to be(false)
        end
      end
    end
  end

  describe '.wrap' do
    context "when passed a Value instance" do
      it "returns the Value instance" do
        expect(Value.wrap(ace)).to be(ace)
      end
    end
    context "when passed an object that can be converted to a Value" do
      context "when passed a full String or Symbol" do
        it "returns a Value" do
          ["Ace", "ace", :Ace, :ace].each do |val|
            val = Value.wrap(val)
            expect(val).to be_an_instance_of(Value)
            expect(val.to_sym).to be(:Ace)
          end
        end
      end
      context "when passed a short String or Symbol" do
        it "returns a Value" do
          ["j", "J", :j, :J].each do |val|
            val = Value.wrap(val)
            expect(val).to be_an_instance_of(Value)
            expect(val.to_sym).to be(:Jack)
          end
        end
      end
      context "when passed an Integer or Float" do
        it "returns a Value" do
          [1, 1.0].each do |val|
            val = Value.wrap(val)
            expect(val).to be_an_instance_of(Value)
            expect(val.to_sym).to be(:Ace)
          end
        end
      end
    end
    context "when passed an object that cannot be coerced to a Value" do
      it "returns nil" do
        ["AceOfSpades", :X, 42, 42.0, true].each do |val|
          val = Value.wrap(val)
          expect(val).to be_nil
        end
      end
    end
  end

  describe '.parse' do
    context "when passed an object that can be converted to a Value Symbol" do
      context "when passed a full String or Symbol" do
        it "returns a Value" do
          ["Ace", "ace", :Ace, :ace].each do |val|
            val = Value.parse(val)
            expect(val).to be(:Ace)
          end
        end
        context "when not a face card" do
          it "returns a value" do
            expect(Value.parse("three")).to be(:Three)
          end
        end
      end
      context "when passed a short String or Symbol" do
        it "returns a Value" do
          ["J", "j", :J, :j].each do |val|
            val = Value.parse(val)
            expect(val).to be(:Jack)
          end
        end
      end
      context "when passed an Integer" do
        it "returns a Value" do
          [1, 1.0, 14.0].each do |val|
            val = Value.parse(val)
            expect(val).to be(:Ace)
          end
        end
      end
    end
    context "when passed an object that cannot be coerced to a Value Symbol" do
      it "returns nil" do
        ["AceOfSpades", "T", 42, true, :X].each do |val|
          val = Value.parse(val)
          expect(val).to be_nil
        end
      end
    end
  end

  describe '#<=>' do
    let(:ace) { Value.new(:Ace) }
    let(:king) { Value.new(:King) }
    context "when passed an argument that cannot be compared to a Value" do
      it "returns nil" do
        expect(ace <=> 5).to be_nil
      end
    end
    context "when passed an argument that is a Value" do
      context "when passed a Value that is greater than receiver" do
        it "returns -1" do
          expect(king <=> ace).to be(-1)
        end
      end
      context "when passed a Value that is less than receiver" do
        it "returns 1" do
          expect(ace <=> king).to be(1)
        end
      end
      context "when passed a Value that is equal to receiver" do
        it "returns 0" do
          expect(ace <=> ace).to be(0)
        end
      end
      context "when aces are low" do
        it "compares them appropriately" do
          deck = Deck.new(aces_high: false)
          card = Card.new(:ace, :spades)
          card.deck = deck
          ace.card = card
          expect(ace <=> king).to be(-1)
        end
      end
    end
  end

  describe '#card & #card=' do
    it "assigns/retrieves the card" do
      expect(ace.card).to be_nil
      ace.card = :Foo
      expect(ace.card).to be(:Foo)
    end
  end

  describe '#aces_high?' do
    it "returns the #aces_high? value of its card" do
      card = Card.new(:ace, :spades)
      ace.card = card
      expect(ace.aces_high?).to be(card.aces_high?)
    end
  end

  describe '#to_sym' do
    it "returns the Value as a Symbol" do
      expect(ace.to_sym).to eq(:Ace)
    end
  end

  describe '#to_s' do
    it "returns the Value as a String" do
      expect(ace.to_s).to eq("Ace")
    end
  end

  describe '#to_str' do
    it "returns the Value as a String" do
      expect(ace.to_str).to eq("Ace")
    end
  end

  describe '#to_i' do
    it "returns the Value as an Integer" do 
      expect(ace.to_i).to be(14)
    end
  end

  describe '#to_int' do
    it "returns the Value as an Integer" do 
      expect(ace.to_int).to be(14)
    end
  end

  describe '#method_missing' do
    context "when a valid predicate method is called" do
      context "when the method called should return true" do
        it "returns true" do
          expect(ace.ace?).to be(true)
        end
      end
      context "when the method called should return false" do
        it "returns false" do
          expect(ace.king?).to be(false)
        end
      end
    end
    context "when an invalid predicate method is called" do
      it "raises NoMethodError" do
        expect{ace.no_method?}.to raise_error(NoMethodError)
      end
    end
    context "when an invalid method is called" do
      it "raises NoMethodError" do
        expect{ace.not_a_method}.to raise_error(NoMethodError)
      end
    end
  end
end
