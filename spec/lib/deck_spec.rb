require 'spec_helper'

describe Deck do
  let(:deck) { Deck.new }
 
  describe '.new' do
    context "when passed valid params" do
      it "initializes with 52 cards" do
        expect(deck.length).to be(52)
      end
      it "initializes with 4 suits" do
        expect(deck.group_by{|c|c.suit.to_sym}.count).to be(4)
      end
      it "initializes with 13 values" do
        expect(deck.group_by{|c|c.value.to_sym}.count).to be(13)
      end
      it "initializes with 13 values per suit" do
        values_per_suit = deck.group_by{|c|c.suit.to_sym}[:Spades].group_by{|c|c.value.to_sym}.count
        expect(values_per_suit).to be(13)
      end
      it "initializes as shuffled" do
        expect(deck[0..12].group_by{|c|c.suit.to_sym}.count).to_not be(1)
        expect(deck[0..12].group_by{|c|c.value.to_sym}.count).to_not be(13)
      end
      it "initializes with aces high" do
        expect(deck.aces_high?).to be(true)
      end
      context "when initialized with (false)" do
        let(:deck) { Deck.new(false) }
        it "creates the deck but does not add any cards" do
          expect(deck.empty?).to be(true)
        end
      end
      context "when initialized with {jokers: true}" do
        let(:deck) { Deck.new(jokers: true) }
        it "initializes with 54 cards" do
          expect(deck.length).to be(54)
        end
        it "initializes with 2 jokers" do
          expect(deck.find_cards(:joker).count).to be(2)
        end
      end
      context "when initialized with {shuffle: false}" do
        let(:deck) { Deck.new(shuffle: false) }
        it "initializes in an unshuffled order by suit" do
          expect(deck[0..12].group_by{|c|c.suit.to_sym}.count).to be(1)
        end
        it "initializes in an unshuffled order by value" do
          deck[0..12].reduce do |memo, card|
            expect(memo.value < card.value).to be(true)
            card
          end
        end
      end
      context "when initialized with {aces_high: false}" do
        let(:deck) { Deck.new(aces_high: false) }
        it "initalizes with aces low" do
          expect(deck.aces_high?).to be(false)
        end
      end
    end
  end

  describe '#find_card' do
    context "when passed an argument" do
      context "when the card exists" do
        it "returns the card" do
          card = deck.find_card(:ace, :spades)
          expect(card.ace_of_spades?).to be(true)
        end
      end
      context "when the card does not exist" do
        it "returns nil" do
          card = deck.find_card(:foo)
          expect(card).to be_nil
        end
      end
    end
    context "when passed a block" do
      it "returns the first card that yields the block as true" do
        card = deck.find_card { |c| c.ace? }
        expect(card.ace?).to be(true)
      end
    end
  end

  describe '#find_cards' do
    context "when passed an argument" do
      context "when there are cards that match the argument" do
        it "returns an array of matching cards" do
          cards = deck.find_cards(:ace)
          expect(cards.count).to be(4)
          cards.each { |c| expect(c.ace?).to be(true) }
        end
      end
      context "when no cards match" do
        it "returns an empty array" do
          cards = deck.find_cards(:foo)
          expect(cards.empty?).to be(true)
        end
      end
    end
    context "when passed a block" do
      it "returns cards that yield as true" do
        cards = deck.find_cards { |c| c.ace? }
        expect(cards.count).to be(4)
        cards.each { |c| expect(c.ace?).to be(true) }
      end
    end
  end

  describe '#add_card' do
    it "adds specified card to self" do
      deck.add_card('ace', 'spades')
      expect(deck.count).to be(53)
      expect(deck.last.to_s).to eq('Ace of Spades')
    end
    it "adds self as card.deck" do
      expect(deck.sample.deck).to be(deck)
    end
  end

  describe '#remove_cards' do
    context "when passed an argument" do
      let(:aces) { deck.remove_cards(:ace) }
      it "removes matching cards from the deck" do
        expect(aces.count).to be(4)
        expect(deck.find{|c|c.ace?}).to be_nil
      end
    end
    context "when passed a block" do
      let(:spades) { deck.remove_cards {|c|c.spade?} }
      it "removes cards that yield to true" do
        expect(spades.count).to be(13)
        expect(deck.find{|c|c.spade?}).to be_nil
      end
    end
  end
  
  describe '#aces_high?' do
    context "when aces are high" do
      it "returns true" do
        expect(deck.aces_high?).to be(true)
      end
    end
    context "when aces are low" do
      it "returns false" do
        deck.aces_high = false
        expect(deck.aces_high?).to be(false)
      end
    end
  end

  describe '#jokers?' do
    context "there is a joker or jokers in the deck" do
      it "returns true" do
        deck.add_card(:joker)
        expect(deck.jokers?).to be(true)
      end
    end
    context "when there are no jokers" do
      it "returns false" do
        expect(deck.jokers?).to be(false)
      end
    end
  end

  describe '#deal' do
    context "when called with no argument" do
      it "deals 1 card when called with no argument" do
         expect(deck.deal).to be_a(Card)
      end
    end
    context "when called with an integer argument" do
      it "deals multiple cards in an array when called with an integer argument" do
        cards = deck.deal(10)
        expect(cards.count).to be(10)
        expect(cards.all?{|c|c.instance_of?(Card)}).to be(true)
      end
    end
    it "removes dealt cards from deck" do
       deck.deal
       expect(deck.count).to be(51)
       deck.deal(9)
       expect(deck.count).to be(42)
    end
    it "stores dealt cards in another array" do
      expect(deck.deal).to be(deck.dealt.first)
      deck.deal(9)
      expect(deck.dealt.count).to be(10)
    end
  end

  describe '#shuffle!' do
    it "shuffles the deck" do
      dup = deck.dup
      expect(deck.shuffle!).to_not eq(dup)
    end
    it "returns dealt cards to the deck before shuffling" do
      deck.deal(10)
      deck.shuffle!
      expect(deck.count).to be(52)
    end
  end

  describe '#shuffle' do
    it "shuffles the deck non-destructively" do
      expect(deck.shuffle).to_not be(deck)
    end
    it "returns dealt cards to the deck before shuffling" do
      deck.deal(10)
      expect(deck.count).to be(42)
      expect(deck.shuffle.count).to be(52)
    end
  end

  describe '#unshuffle!' do
    let(:deck) { Deck.new(jokers: true) }
    it "returns any dealt cards to the deck" do
      deck.deal(10)
      expect(deck.unshuffle!.count).to be(54)
    end
    it "sorts the deck from lowest to highest" do
      deck.remove_cards(:joker)
      deck.unshuffle!.reduce do |memo, card|
        expect(memo < card).to be(true)
        card
      end
    end
  end

  describe '#unshuffle' do
    let(:deck) { Deck.new(jokers: true, shuffle:true) }
    it "it unshuffles nondestructively" do
      deck.deal(10)
      expect(deck.unshuffle.count).to be(54)
      expect(deck.count).to be(44) 
    end
    it "sorts the deck from lowest to highest nondestructively" do
      deck.remove_cards(:joker)
      deck.unshuffle.reduce do |memo, card|
        expect(memo < card).to be(true)
        card
      end
      first_suit = deck[0..12].group_by{|c|c.suit.to_sym}
      expect(first_suit.count).to_not be(1)
    end
  end

  describe '#valid?' do
    describe "without jokers" do
      context "when valid" do
        it "returns true" do
          expect(deck.valid?).to be(true)
        end
      end
      context "when invalid" do
        context "when wrong length" do
          it "returns false" do
            deck.remove_cards(:spades)
            expect(deck.valid?).to be(false)
          end
        end
        context "when wrong cards" do
          it "returns false" do
            deck.remove_cards(:ace, :spades)
            deck.add_card(:king, :spades)
            expect(deck.valid?).to be(false)
          end
        end
      end
    end
  end
  describe "with jokers" do
    let(:deck) { Deck.new(jokers: true) }
    context "when valid" do
      it "returns true" do
        expect(deck.valid?).to be(true)
      end
    end
    context "when invalid" do
      context "when wrong cards" do
        it "returns false" do
          deck.remove_cards(:ace, :spades)
          deck.add_card(:joker)
          expect(deck.valid?).to be(false)
        end
      end
    end
  end
end
