helpers do
  def initialize_decks
    #make a deck
    suits = ['d', 'h', 's', 'c']
    cards = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
    session[:deck] = cards.product(suits).shuffle!
  end

  def clear_hands 
    session[:player_hand] = []
    session[:dealer_hand] = []
    session[:dealer_turn] = false
  end

  def deal_card(hand)
    hand << session[:deck].pop
    if session[:deck].length < 11
      initialize_decks
    end
  end

  def test(str)
    str
  end

  def show_cards
    system 'clear'
    puts '----------- Dealer Cards ----------- '
    display_hand(@dealer_hand)
    puts ''
    puts '----------- Player Cards ----------- '
    display_hand(@player_hand)
    puts ''
  end

  def display_hand (hand)
    #hand is array like [["A", "D"], ["K", "S"], ["10", "H"]]
    c1 = c2 = c3 = c4 = c5 = ""
    hand.each do |h|
      spacer = h[0].length < 2 ? " " : ""
      c1 += "+----+  "
      c2 += "|    |  "
      c3 += "|#{spacer}#{h[0]}#{h[1].downcase} |  "
      c4 += "|    |  "
      c5 += "+----+  "
    end
    puts c1, c2, c3, c4, c5
  end

  def hand_value(hand)
    total = 0
    #add 10 for face cards and face value for number cards and 11 for aces
    cards = hand.map{|c| c[0]}
    cards.each do |c|
      if c == "A"
        total += 11
      elsif c.to_i == 0
        total += 10
      else
        total += c.to_i 
      end
    end
    cards.select! { |c| c == "A"}
    cards.each do |c|
      if total > 21
        total -= 10
      end
    end
    total
  end

end