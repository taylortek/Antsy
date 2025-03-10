SMODS.Blind {
    key = "crunch",
    loc_txt = {name = "The Crunch", text = {"Divide mult by", "remaining hands"}},
    mult = 2,
    boss = {min = 1, max = 100},
    boss_colour = HEX('ffadfc'),
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        if G.GAME.current_round.hands_left > 0 then
            return math.floor(mult/G.GAME.current_round.hands_left), hand_chips, true
        else
            return mult, hand_chips, true
        end
    end
}

print("Antsy blinds loaded...")