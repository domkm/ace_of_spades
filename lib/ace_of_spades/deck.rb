class AceOfSpades::Deck < Array
  attr_reader :dealt
  attr_writer :aces_high

  def initialize(opts = {})
    super()
    @dealt, @aces_high = [], true
    return self unless opts
    opts = {shuffle: true, jokers: false, aces_high: true, jokers: false}.merge(opts)
    @aces_high = opts[:aces_high]
    initialize_cards(opts)
  end

  def find_card(*args, &block)
    find_cards(*args, &block).first
  end

  def find_cards(*args, &block)
    args.map! { |arg| Value.parse(arg) || Suit.parse(arg) || (:joker if %r(\Ajoker\z)i === arg) }.compact!
    cards.each_with_object([]) do |card, arr|
      arr.push(card) if ( !args.empty? && args.all? { |arg| card.send("#{arg}?") } ) || ( block.call(card) if block_given? )
    end
  end

  def add_card(*args)
    card = Card.new(*args)
    card.deck = self
    push(card)
  end

  def remove_cards(*args, &block)
    to_be_removed = find_cards(*args, &block)
    delete_if { |card| to_be_removed.include?(card) }
    @dealt.delete_if { |card| to_be_removed.include?(card) }
    to_be_removed
  end

  def aces_high?
    !!@aces_high
  end

  def jokers?
    cards.any? { |card| card.joker? }
  end

  def deal(num = 1)
    dealt = shift(num)
    @dealt.concat(dealt)
    num > 1 ? dealt : dealt.first
  end

  def shuffle!
    concat(@dealt)
    @dealt.clear
    super
  end

  def shuffle
    dup.shuffle!
  end

  def unshuffle!
    concat(@dealt)
    @dealt.clear
    jokers = remove_cards(:joker)
    sort!.concat(jokers)
  end

  def unshuffle
    dup.unshuffle!
  end
  
  def initialize_cards(opts = {})
    VALUES[1..-1].product(SUITS) { |value, suit| add_card(value, suit) }
    2.times { add_card(:joker) } if opts[:jokers]
    opts[:shuffle] ? shuffle! : unshuffle!
  end
  
  def valid?
    deck = unshuffle
    return true if deck.remove_cards(:joker).count == 2 && deck.valid?
    deck.reduce  do |memo, card| 
      return false unless memo < card
      card
    end
    return false unless deck.count == 52
    true
  end

  private
  
  def cards
    self + @dealt
  end
end
