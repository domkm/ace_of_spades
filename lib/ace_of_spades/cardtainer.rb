class AceOfSpades::Cardtainer < Array
  def initialize
    super
  end

  class << self
    undef_method :[], :try_convert
    def convert(obj)
      return obj if obj.instance_of?(Cardtainer)
      return nil unless obj.is_a?(Array)
      obj.each_with_object(Cardtainer.new) do |card, cardtainer|
        cardtainer << card if card.instance_of? Card
      end
    end
  end
end
