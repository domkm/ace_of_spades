module AceOfSpades
  VALUES = [:Ace, :Two, :Three, :Four, :Five, :Six, :Seven, :Eight, :Nine, :Ten, :Jack, :Queen, :King, :Ace]
  SUITS  = [:Clubs, :Diamonds, :Hearts, :Spades]
end

%w[cardtainer deck card value suit].each do |file|
  require "ace_of_spades/#{file}"
end
