class AceOfSpades::Card
  include Comparable
  attr_reader :value, :suit
  attr_accessor :deck

  def initialize(*args)
    first, second  = args[0] || false, args[1] || false
    @value, @suit  = Value.wrap(first), Suit.wrap(second)
    @value, @suit  = first, second if @value.nil? && @suit.nil?
    @value = @suit = nil if args.count == 1 && /\Ajoker\z/i === first
    @value.card = @suit.card = self unless joker?
    validate!
  end

  def self.wrap(*args)
    return args.first if args.first.instance_of?(Card)
    Card.new(*args)
  rescue
    nil
  end

  def value=(v)
    @value = Value.wrap(v)
  end

  def suit=(s)
    @suit = Suit.wrap(s)
  end

  def <=>(card)
    return nil if !card.instance_of?(Card) || card.joker?
    suit_comparison = suit <=> card.suit
    return suit_comparison unless suit_comparison == 0
    value <=> card.value
  end

  def aces_high?
    return true if deck.nil?
    deck.aces_high?
  end
    
  def joker?
    value.nil? && suit.nil?
  end

  def to_s
    return 'Joker' if joker?
    "#{value.to_s} of #{suit.to_s}"
  end

  def to_sym
    to_s.to_sym
  end

  def valid?
    return true if joker?
    value.instance_of?(Value) && suit.instance_of?(Suit)
  end

  def validate!
    valid? ? self : invalidate!
  end

  def method_missing(method, *args, &block)
    return super unless match = %r(.+\?\z).match(method).to_s.chop.split('_')
    v, s = match.first, match.last
    valuable, suitable = Value.valuable?(v), Suit.suitable?(s)
    if joker? && (suitable || valuable)
      false
    elsif valuable && suitable
      value.send("#{v}?") && suit.send("#{s}?")
    elsif match.count >= 2
      super
    elsif valuable
      value.send("#{v}?")
    elsif suitable
      suit.send("#{s}?")
    else
      super
    end
  end

  private

  def invalidate!
    raise "Invalid Card: @value = #{value}, @suit = #{suit}"
  end
end
