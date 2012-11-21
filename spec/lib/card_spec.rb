require "spec_helper"

describe Card do
  let(:ace_spades) { Card.new(:ace, :spades) }
  let(:joker) { Card.new(:joker) }

  describe '.new' do
    context "when called with valid arguments" do
      let(:ten_hearts) { Card.new(10, 'h') }
      it "initializes" do
        expect(ace_spades).to be_an_instance_of(Card)
        expect(ten_hearts).to be_an_instance_of(Card)
      end
      it "correctly saves the suit" do
        expect(ace_spades.suit.to_sym).to be(:Spades)
        expect(ten_hearts.suit.to_sym).to be(:Hearts)
      end
      it "correctly saves the value" do
        expect(ace_spades.value.to_sym).to be(:Ace)
        expect(ten_hearts.value.to_sym).to be(:Ten)
      end
      it "saves self as value.card and suit.card" do
        expect(ace_spades.value.card).to be(ace_spades)
        expect(ace_spades.suit.card).to be(ace_spades)
      end
      context "when a joker" do
        it "initializes as a joker" do
          expect(joker.suit).to be_nil
          expect(joker.value).to be_nil
        end
      end
    end
    context "when initialized with invalid arguments" do
      it "raises an error" do
        expect{Card.new}.to raise_error
        expect{Card.new(:joker, :foo)}.to raise_error
        expect{Card.new(:ace, :foo)}.to raise_error
        expect{Card.new('a', 5)}.to raise_error
        expect{Card.new(:foo)}.to raise_error
      end
    end
  end

  describe '.wrap' do
    context "when passed a Card instance" do
      it "returns the card instance" do
        expect(Card.wrap(joker)).to be(joker)
      end
    end
    context "when passed arguments that can be converted into a Card instance" do
      it "returns the arguments as a Card instance" do
        expect(Card.wrap(:ace, :spades)).to eq(ace_spades)
      end
    end
    context "when passed arguments that cannot me converted into a Card instance" do
      it "returns nil" do
        expect(Card.wrap(:foo)).to be_nil
      end
    end
  end

  describe '#value=' do
    let(:card) { ace_spades }
    context "when passed a Value instance" do
      it "assigns the Value" do
        card.value = Value.new(:king)
        expect(card.value).to be_an_instance_of(Value)
        expect(card.value.to_sym).to be(:King)
      end
    end
    context "when passed an object that can be converted to a Value" do
      it "assigns the Value" do
        card.value = :king
        expect(card.value).to be_an_instance_of(Value)
        expect(card.value.to_sym).to be(:King)
      end
    end
    context "when passed an object that cannot be converted to a Value" do
      it "assigns nil" do
        card.value = :foo
        expect(card.value).to be_nil
      end
    end
  end

  describe '#suit=' do
    let(:card) { ace_spades }
    context "when passed a Suit instance" do
      it "assigns the Suit" do
        card.suit = Suit.new(:hearts)
        expect(card.suit).to be_an_instance_of(Suit)
        expect(card.suit.to_sym).to be(:Hearts)
      end
    end
    context "when passed an object that can be converted to a Suit" do
      it "assigns the Suit" do
        card.suit = :hearts
        expect(card.suit).to be_an_instance_of(Suit)
        expect(card.suit.to_sym).to be(:Hearts)
      end
    end
    context "when passed an object that cannot be converted to a Suit" do
      it "assigns nil" do
        card.suit = :foo
        expect(card.suit).to be_nil
      end
    end
  end

  describe '#deck & #deck=' do
    let(:deck) { Deck.new }
    let(:card) { ace_spades }
    it "retrieves the deck" do
      expect(card.deck).to be_nil
    end
    it "assigns the deck" do
      card.deck = deck
      expect(card.deck).to be(deck)
    end
  end

  describe '#aces_high?' do
    let(:deck) { Deck.new(aces_high: true) }
    let(:card) { ace_spades }
    it "returns the #aces_high? result from the deck" do
      card.deck = deck
      expect(card.aces_high?).to be(true)
      deck.aces_high = false
      expect(card.aces_high?).to be(false)
    end
    context "when the card has no deck" do
      it "returns true" do
        expect(card.aces_high?).to be(true)
      end
    end
  end

  describe'#<=>' do
    let(:ace_hearts) { Card.new(14, :H) }
    let(:king_spades) { Card.new(13, :S) }
    let(:king_hearts) { Card.new(13, :H) }
    context "when passed an incomparable object" do
      it "returns nil" do
        expect(ace_spades <=> 5).to be_nil
      end
    end
    context "when passed a card with the same value and suit" do
      let(:ace_of_spades) { Card.new(14, :S) }
      it "returns 0" do
        expect(ace_spades <=> ace_of_spades).to be(0)
      end
    end
    context "when passed a card with a higher suit" do
      it "returns -1" do
        expect(ace_hearts <=> ace_spades).to be(-1)
      end
    end
    context "when passed a card with a lower suit" do
      it "returns 1" do
        expect(ace_spades <=> ace_hearts).to be(1)
      end
    end
    context "when passed a card with a higher suit and a lower value" do
      it "returns -1" do
        expect(ace_hearts <=> king_spades).to be(-1)
      end
    end
    context "when passed a card with a lower suit and a higher value" do
      it "returns 1" do
        expect(king_spades <=> ace_hearts).to be(1)
      end
    end
    context "when passed a joker" do
      it "returns nil" do
        expect(ace_spades <=> joker).to be_nil
      end
    end
    describe Comparable do
      it "compares correctly" do
        expect(ace_spades == ace_spades).to be(true)
        expect(ace_hearts < ace_spades).to be(true)
        expect(ace_spades > ace_hearts).to be(true)
      end
    end
  end
  
  describe '#to_s' do
    context "when a joker" do
      it "returns 'Joker'" do
        expect(joker.to_s).to eq('Joker')
      end
    end
    context "when not a joker" do
      it "returns 'Value of Suit'" do
        expect(ace_spades.to_s).to eq('Ace of Spades')
      end
    end
  end

  describe '#to_sym' do
    context "when a joker" do
      it "returns :Joker" do
        expect(joker.to_sym).to eq(:Joker)
      end
    end
    context "when not a joker" do
      it "returns :'Value of Suit'" do
        expect(ace_spades.to_sym).to eq(:'Ace of Spades')
      end
    end
  end

  describe '#valid?' do
    context "when valid" do
      it "returns true" do
        expect(ace_spades.valid?).to be(true)
        expect(joker.valid?).to be(true)
      end
    end
    context "when invalid" do
      it "returns false" do
        ace_spades.instance_variable_set(:@value, 'foo')
        ace_spades.instance_variable_set(:@suit, 'bar')
        expect(ace_spades.valid?).to be(false)
      end
    end
  end
  describe '#joker?' do
    context "when a joker" do
      it "returns true" do
        expect(joker.joker?).to be(true)
      end
    end
    context "when not a joker" do
      it "returns false" do
        expect(ace_spades.joker?).to be(false)
      end
    end
  end

  describe '#validate!' do
    context "when valid" do
      it "returns self" do
        expect(ace_spades.validate!).to be(ace_spades)
      end
    end
    context "when invalid" do
      it "raises error" do
        ace_spades.instance_variable_set(:@value, false)
        ace_spades.instance_variable_set(:@suit, false)
        expect{ace_spades.validate!}.to raise_error
      end
    end
  end

  describe '#method_missing' do
    context "when passed a valid predicate method" do
      context "when a value" do
        it "returns true or false" do
          expect(ace_spades.ace?).to be(true)
          expect(ace_spades.king?).to be(false)
          expect(joker.ace?).to be(false)
        end
      end
      context "when a suit" do
        it "returns true or false" do
          expect(ace_spades.spade?).to be(true)
          expect(ace_spades.spades?).to be(true)
          expect(ace_spades.hearts?).to be(false)
          expect(joker.spades?).to be(false)
        end
      end
      context "when a value and suit" do
        it "returns true or false" do
          expect(ace_spades.ace_spades?).to be(true)
          expect(ace_spades.ace_of_spades?).to be(true)
          expect(ace_spades.ace_of_hearts?).to be(false)
          expect(ace_spades.king_spades?).to be(false)
        end
      end
    end
    context "when passed an invalid predicate method" do
      it "raises error" do
        expect{ace_spades.foo?}.to raise_error(NoMethodError)
        expect{ace_spades.ace_foo?}.to raise_error(NoMethodError)
      end
    end
    context "when passed an invalid method" do
      it "raises error" do
        expect{ace_spades.foo}.to raise_error(NoMethodError)
      end
    end
  end
end
