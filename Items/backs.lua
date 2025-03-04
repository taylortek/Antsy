SMODS.Back{
    name = "Test Deck",
    key = "test",
    atlas = "antsybackatlas",
    pos = {x = 0, y = 0},
    loc_txt = {
        name ="Test Deck",
        text={
            "Start with custom cards"
        },
    },
    config = {
        voucher = "v_antsy_test"
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.jokers.config.card_limit = 100
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_debris"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_land_mine",
                    edition = "e_negative"
                })
                SMODS.add_card({
                    set = "Taro",
                    key = "c_hanged_man"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_chain_smoker"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_undead_theif"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_alien_monarch"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_gladiator"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_detective"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_demonic_assassin"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_antsy_cowboy"
                })
                SMODS.add_card({
                    set = "joker",
                    key = "j_antsy_the_coder"
                })
                SMODS.add_card({
                    set = "joker",
                    key = "j_antsy_smoke_and_mirrors"
                })
                SMODS.add_card({
                    set = "Spectral",
                    key = "c_antsy_emf"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_blueprint"
                })
                return true
            end
        }))
    end
}

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