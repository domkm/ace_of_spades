# Ace Of Spades

A simple and flexible playing cards library.

## Installation

Add this line to your application's Gemfile:

    gem 'ace_of_spades', '~> 0.0.1.pre'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ace_of_spades --pre

## Usage

    require "ace_of_spades"
    include AceOfSpades

### Deck

Deck accepts an optional hash for initialization. Defaults are: `{aces_high: true, shuffle: true, jokers: false}`

    deck = Deck.new(shuffle: false, jokers: true)
    => [Two of Clubs, Three of Clubs, Four of Clubs, Five of Clubs, . . . Jack of Spades, Queen of Spades, King of Spades, Ace of Spades, Joker, Joker]

Deck also accepts `false` to initialize without initializing cards.

    deck = Deck.new(false)
    => []

Cards can be initialized later with `#initialize_cards`

    deck.initialize_cards(shuffle: false, jokers: true)
    => [Two of Clubs, Three of Clubs, Four of Clubs, Five of Clubs, . . . Jack of Spades, Queen of Spades, King of Spades, Ace of Spades, Joker, Joker]
    
Deck is array-like and can be manipulated like an array. All Array and Enumerable methods are available.

    deck.first
    => Two of Clubs
    
Ace ranking can be retrieved and set with `#aces_high?` and `#aces_high=`

    deck.aces_high?
    => true
    deck.aces_high = false
    => false
    deck.aces_high?
    => false
    
Cards can be added with `#add_card`

    deck.add_card(:ace, :spades)
    deck.last
    => Ace of Spades

Any card-related methods on Deck accept valid arguments for Card.new (outlined below).

Specific cards can be found with `#find_cards`. It can accept arguments and/or a block. It will return all cards that match the arguments or for which the block evaluates to true.

    deck.find_cards(:ace) { |card| card.joker? }
    =>[Ace of Clubs, Ace of Diamonds, Ace of Hearts, Ace of Spades, Joker, Joker]

Similarly, `#find_card` will return the first card that the arguments match or for which the block evaluates to true.

    deck.find_card(:spade) { |card| card.ace? }
    => Ace of Clubs

`Ace of Clubs` was returned because the block evaluated to true. If no matching cards are found, `#find_cards` will return `nil`.

`#remove_cards` works just like `#find_cards`, but will remove all matching cards from the deck.

    deck.jokers?
    => true
    deck.remove_cards(:joker)
    => [Joker, Joker]
    deck.jokers?
    => false
    
`#deal` will remove the specified number of cards from the deck, store them separately, and return them. The default argument is 1.

    deck.deal
    => Two of Clubs
    deck.count
    => 51
    deck.deal(9)
    => [Three of Clubs, Four of Clubs, Five of Clubs, Six of Clubs, Seven of Clubs, Eight of Clubs, Nine of Clubs, Ten of Clubs, Jack of Clubs]
    deck.count
    => 42
    
`#shuffle`, `#shuffle!`, `#unshuffle`, `#unshuffle!`, do exactly what you'd think. The first two shuffle the deck and the last two unshuffle it (sorted from lowest to highest card). The bang versions are destructive.

`#valid?` returns true if the deck consists of 13 different cards from each suit and 0 or 2 jokers.

    deck.valid?
    => true
    deck.remove_cards(:ace, :spades)
    deck.valid?
    => false

### Card

Card accepts a value and a suit for initialization. The value can be an integer (1-14), a face card name, or the first letter of a face card name. The latter two can be symbols or strings and are case insensitive. The suit can be the plural or singular name of a suit or the first letter of the name of the suit. Again, symbols or strings are accepted and are case insensitive. Example: `Card.new` with `(:ace, :spades)`, `("ACE", :spades)`, `(:ace, "Spade")`, `(1, :spades)`, `(14, :spades)`, `(:A, :S)`, `("a", :spade)`,  etc., would all produce the same card.

    card = Card.new(:ace, :spades)
    => Ace of Spades
    
A joker is a card with neither a value or suit and can be initialized by passing in `joker`.

    joker = Card.new(:joker)
    => Joker
    
`.wrap` will return the same instance of Card that is passed in if a Card instance is passed in, a new Card instance if valid arguments are passed in, or nil if invalid arguments are passed.
    
    Card.wrap(card)
    => Ace of Spades
    Card.wrap('ace', 'spade')
    => Ace of Spades
    Card.wrap('foo')
    => nil
    
Both suit and value have readers and writers defined. Setting a suit or value will first wrap the argument in the proper class.

    card.value
    => Ace
    card.value = 5
    card.value
    => Five
    
Cards can be compared.

    ace = Card.new(:ace, :spades)
    king = Card.new(:king, :spades)
    ace > king
    => true

Cards are compared by suit first and, in the event of a tie, by value. Aces respect the `aces_high` boolean value of the parent deck.

`#to_s` and `#to_sym` convert a card to a String and Symbol respectively.

    ace.to_s
    => "Ace of Spades"
    ace.to_sym
    => :"Ace of Spades"

Cards respond to valid predicate methods that are dynamically defined based on valid values and suits.

    ace.joker? || ace.heart?
    => false
    ace.ace? && ace.spade? && ace.spades? && ace.ace_of_spades? && ace.a? && ace.s?
    => true
    ace.foo?
    => NoMethodError: undefined method 'foo?'

`#valid` checks whether a card is valid. A card is considered valid if it has a valid value and suit or if both the value and suit are `nil` (joker).
  
    ace.valid?
    => true
    ace.suit = :foo
    ace.valid?
    => false

### Value & Suit

In general you shouldn't have to touch Value and Suit since Deck and Card handle this for you. However, their interfaces are very similar to Card, if you need to use them directly.

## Roadmap

* Abstract Deck functionality into a container class (Cardtainer?) from which Deck, Metadeck (deck of decks), Hand, and Game will inherit
* Implement Hand, Metadeck, and Game
* Implement customizable logic for joker comparison, Hand comparison, Suit ranking, and Deck validation
* Extract shared parsing functionality into a Parser module
* Extract shared functionality of Value and Suit into a module
* Separate unit and integration tests
* Add YARD documentation


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes and tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
