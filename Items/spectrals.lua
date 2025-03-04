-- EMP
-- code state: mid
SMODS.Consumable {
    key = "emf",
    set = "Spectral",
    atlas = "antsytarotatlas",
    pos = {x=0,y=0},
    loc_txt = {name="EMF", text={'Destroys 2 random cards,', 'held in hand,', 'applies negative to 3 others.'}},

    config = {
    },

    use = function(self, card, area, copier)
        local destroyed_cards = {}
        for i=1,2 do
            destroyed_cards[i] = pseudorandom_element(G.hand.cards, pseudoseed('test_spectral'))
            destroyed_cards[i]:start_dissolve()
        end
        G.E_MANAGER:add_event(Event({
            func = function()
                for i=1, 3 do
                    pseudorandom_element(G.hand.cards, pseudoseed('test_spectral')):set_edition({negative = true}, true, true)
                end
                return true
            end
        }))
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
        end
    end,
    
    can_use = function(self, card)
        if #G.hand.cards > 0 then
            return true
        else
            return false
        end
    end,
}

print("Antsy spectrals loaded...")