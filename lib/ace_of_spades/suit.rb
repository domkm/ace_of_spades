class AceOfSpades::Suit
  include Comparable
  attr_accessor :card
  
  def initialize(suit)
    @symbol = Suit.parse(suit)
    raise "Invalid argument: #{suit}" unless @symbol
  end

  def <=>(suit)
    return nil unless suit.instance_of?(Suit)
    SUITS.index(@symbol) <=> SUITS.index(suit.to_sym)
  end

  def to_sym
    @symbol
  end

  def to_s
    @symbol.to_s
  end
  alias_method :to_str, :to_s

  def method_missing(method, *args, &block)
    match = Suit.parse(%r(.+\?\z).match(method).to_s.chop)
    return super unless match
    @symbol == match
  end

  class << self
    def suitable?(suit)
      !!parse(suit)
    end
    
    def wrap(suit)
      return suit if suit.instance_of?(Suit)
      new(suit) if suitable?(suit)
    end

    def parse(arg)
      regex = arg.to_s.length == 1 ? %r(\A#{arg})i : %r(\A#{arg}(s*)\z)i
      SUITS.grep(regex).first
    end
  end
end
