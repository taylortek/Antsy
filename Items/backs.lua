SMODS.Back{
    name = "Negative Deck",
    key = "negative_deck",
    pos = {x = 0, y = 0},
    atlas = "antsybackatlas",
    loc_txt = {
        name ="Negative Deck",
        text={
            "Start with all negative cards"
        },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function ()
                for _,card in ipairs(G.playing_cards) do
                    card:set_edition({negative = true}, true, true)
                end
                return true
            end
        }))
    end
}

print("Antsy backs loaded...")