class AceOfSpades::Value
  include Comparable
  attr_accessor :card

  def initialize(value)
    @symbol = Value.parse(value)
    raise "Invalid argument: #{value}" unless @symbol
  end

  def <=>(value)
    return nil unless value.instance_of?(Value)
    to_i <=> value.to_i
  end

  def to_sym
    @symbol
  end

  def to_s
    @symbol.to_s
  end
  alias_method :to_str, :to_s

  def to_i
    aces_high? ? VALUES.rindex(@symbol) + 1 : VALUES.index(@symbol) + 1
  end
  alias_method :to_int, :to_i

  def aces_high?
    return true unless card
    card.aces_high?
  end

  def method_missing(method, *args, &block)
    match = Value.parse(%r(.+\?\z).match(method).to_s.chop)
    return super unless match
    @symbol == match
  end

  class << self
    def valuable?(value)
      !!parse(value)
    end
    
    def wrap(value)
      return value if value.instance_of?(Value)
      new(value) if valuable?(value)
    end

    def parse(arg)
      return VALUES[arg - 1] if (1..14).include?(arg)
      short_arg = arg.to_s.length == 1
      regex  = short_arg ? %r(\A#{arg})i  : %r(\A#{arg}\z)i
      values = short_arg ? VALUES[-4..-1] : VALUES
      values.grep(regex).first
    end
  end
end
