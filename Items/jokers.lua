CARD_RANKS = {'2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace'}

-- Land Mine
-- code state: don't touch
SMODS.Joker {
    key = 'land_mine',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 4,
        y = 0
    },
    config = {
    },
    cost = 4,
    loc_txt = {name='Land Mine', text= { 'Destroys all jokers and', 'gives max amount of debris', 'jokers on removal.' }},
    unlocked = true,
    discovered = true,
    rarity = 1,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    for i = 1, #G.jokers.cards do
                        G.jokers.cards[i]:start_dissolve()
                    end 
                    for i = 1, G.jokers.config.card_limit do
                        SMODS.add_card({
                            set = "Joker",
                            key = "j_antsy_debris"
                        })
                    end
                    return true
                end
            }))
        end
    end,

}

-- Debris
-- code state: decent
SMODS.Joker {
    key = 'debris',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 5,
        y = 0
    },
    config = {
        extra = {
            mult = 10
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Debris', text= { '{C:mult}+#1#{} Mult' }},
    unlocked = true,
    discovered = true,
    rarity = 1,
    cost = 4,
    calculate = function(self, card, context)
        if context.joker_main then
             return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
             }
        end
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
}

-- Chain Smoker
-- code state: decent
SMODS.Joker {
    key = 'chain_smoker',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 8,
        y = 0
    },
    cost = 7,
    config = {
        extra = {
            mult = 4,
            cost = 3
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Chain Smoker', text= { '{X:mult,C:white} X#1#{} Mult', '{C:money} -#2#${} per hand played' }},
    unlocked = true,
    discovered = true,
    rarity = 3,
    calculate = function(self, card, context)
        if context.joker_main then
            ease_dollars(-card.ability.extra.cost)
             return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.mult}},
                Xmult_mod = card.ability.extra.mult
             }
        end
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.cost } }
	end,
}

-- Undead Theif
-- code state: decent
SMODS.Joker {
    key = 'undead_theif',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 0,
        y = 0
    },
    cost = 7,
    config = {
        extra = {
            odds = 10
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Undead Theif', text= { 'Each scored Diamond has a', '{C:green}1 in #1#{} chance to give', 'a random {C:spectral}spectral{}' }},
    unlocked = true,
    discovered = true,
    rarity = 3,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.base.suit == "Diamonds" then
                if pseudorandom('undead_theif') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    SMODS.add_card({
                        set = "Spectral"
                    })
                    return {
                        message = localize('k_plus_spectral'),
                        card = context.other_card
                    }
                end
                return {
                    message = localize('k_nope_ex'),
                    card = context.other_card
                }
            end
         end
    end,
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.odds } }
    end
}

-- Alian Monarch
-- code state: fine
SMODS.Joker {
    key = 'alien_monarch',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 1,
        y = 0
    },
    cost = 7,
    config = {
        extra = {
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Alien Monarch', text= { 'If discard is a', 'single {C:clubs}club{}, upgrade', 'it\'s rank' }},
    unlocked = true,
    discovered = true,
    rarity = 3,
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff then
            if #context.full_hand == 1 and context.other_card.base.suit == "Clubs" and context.other_card:get_id() ~= 14 then
                card:juice_up(0.3, 0.4)
                SMODS.change_base(context.other_card, nil , CARD_RANKS[context.other_card:get_id()])
                return {
                    message = localize('k_level_up_ex'),
                    card = context.other_card
                }
            end
        end
    end
}

-- Gladiator
-- code state: cursed
SMODS.Joker {
    key = 'gladiator',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 6,
        y = 0
    },
    config = {
        extra = {
            mult = 4,
            do_this = true,
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Gladiator', text= { '{C:mult}+#1#{} Mult per card in hand' }},
    unlocked = true,
    discovered = true,
    rarity = 2,
    cost = 4,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.do_this = true
        end
        if context.individual and context.cardarea == G.hand and card.ability.extra.do_this and not context.other_card.debuff then
             return {
                mult = card.ability.extra.mult,
                --message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
             }
        end
        if context.after then
            card.ability.extra.do_this = false
        end
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
}

-- Detective
-- code state: decent
SMODS.Joker {
    key = 'detective',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 7,
        y = 0
    },
    config = {
        extra = {
            chips = 1,
            actual_chips = 0
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Detective', text= { '{C:chips}+X{} chips per discarded card.', 'Resets after completing blind', '{C:inactive}Currently:{} {C:chips}+#2#{}' }},
    unlocked = true,
    discovered = true,
    rarity = 3,
    cost = 4,
    calculate = function(self, card, context)
        if context.discard and context.cardarea == G.jokers and not context.other_card.debuff then
            card.ability.extra.actual_chips = card.ability.extra.actual_chips + context.other_card.base.nominal
            return {
                message = localize('k_upgrade_ex'),
                card = card,
                colour = G.C.CHIPS
            }
        end
        if context.joker_main then
             return {
                chips = card.ability.extra.actual_chips,
             }
        end
        if context.end_of_round then
            card.ability.extra.actual_chips = 0
        end
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.actual_chips } }
	end,
}

--dmonic assassin
-- code state: cursed
SMODS.Joker {
    key = 'demonic_assassin',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 2,
        y = 0
    },
    config = {
        extra = {
            do_this = true
        }
    },
    blueprint_compat = false,
    loc_txt = {name='Demonic Assassin', text= { 'If scored hand contains 3', 'or more {C:spades}spades{}, destroy the', 'leftmost card held in hand.' }},
    unlocked = true,
    discovered = true,
    rarity = 3,
    cost = 4,
    calculate = function(self, card, context)
        -- This fucking code makes me want to kill myself. I fucked it up so bad T-T
        if context.destroy_card and context.cardarea == G.hand and card.ability.extra.do_this then
            card.ability.extra.do_this = false
            local spades = 0
            for _,score_card in ipairs(context.scoring_hand) do
                if score_card.base.suit == "Spades" then
                    spades = spades + 1
                end
            end
            if spades >= 3 then
                return {
                    remove = true
                }
            else
                return {
                    remove = false
                }
            end
        end
        if context.after then
            card.ability.extra.do_this = true
        end
    end,
}

-- Cowboy
-- code state: decent
SMODS.Joker {
    key = 'cowboy',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 9,
        y = 0
    },
    config = {
        extra = {
            mult = 1
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Cowboy', text= { 'Gains {X:mult,C:white}X0.2{} mult', 'for each scored 6. Resets', 'upon beating the Boss Blind.', '{C:inactive}Currently:{} {X:mult,C:white}X#1#{}' }},
    unlocked = true,
    discovered = true,
    rarity = 2,
    cost = 4,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 6 then
                card.ability.extra.mult = card.ability.extra.mult + 0.2
            end
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.mult } }
            }
        end
        if context.end_of_round then
            if G.GAME.blind.boss then
                card.ability.extra.mult = 1
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
}

-- The Coder
-- code state: decent
SMODS.Joker {
    key = 'the_coder',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 1,
        y = 1
    },
    soul_pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            mult = 10
        }
    },
    blueprint_compat = true,
    loc_txt = {name='The Coder', text= { 'Gain 2 tags upon', 'selecing blind' }},
    unlocked = true,
    discovered = true,
    rarity = 4,
    cost = 4,
    calculate = function(self, card, context)
        if context.setting_blind then
            for i=1,2 do
                local tag_key = get_next_tag_key("the_coder")
                while tag_key == "tag_boss" do
                    tag_key = get_next_tag_key("the_coder")
                end
                local tag = Tag(tag_key)
                if tag.name == "Orbital Tag" then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then
                            _poker_hands[#_poker_hands + 1] = k
                        end
                    end
                    tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed("cry_pickle_orbital"))
                end
                add_tag(tag)
            end
        end
    end
}

-- Smoke and Mirrors
-- code state: ehhhhh
SMODS.Joker {
    key = 'smoke_and_mirrors',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 0,
        y = 1
    },
    config = {
        extra = {
            mult = 3,
            actual_mult = 0
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Smoke and Mirrors', text= { 'Gains {C:mult}+#1# mult{}', 'every time a card', 'is destroyed.', '{C:inactive}Currently:{} {C:mult}+#2#{}' }},
    unlocked = true,
    discovered = true,
    rarity = 2,
    cost = 4,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.actual_mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.actual_mult } }
             }
        end
        if context.remove_playing_cards then
            for _,removed in ipairs(context.removed) do
                card.ability.extra.actual_mult = card.ability.extra.actual_mult+card.ability.extra.mult
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.actual_mult } }
	end,
}

-- Split Custody
SMODS.Joker {
    key = 'split_custody',
    atlas = 'antsyjokeratlas',
    pos = {
        x = 3,
        y = 1
    },
    config = {
        extra = {
            chip_mod = 15,
            mult_mod = 2,
            mult = 0,
            chips = 0,
        }
    },
    blueprint_compat = true,
    loc_txt = {name='Split Custody', text= { 'If hand is', 'even add {C:mult}+#1#{} Mult to joker,', 'odd add {C:chips}+#2#{} Chips to joker', '{C:inactive}Currently{} {C:mult}+#3#{} {C:chips}+#4#{}' }},
    unlocked = true,
    discovered = true,
    rarity = 2,
    cost = 4,
    calculate = function(self, card, context)
        if context.joker_main then
            local sum = 0
            for _,playing_card in ipairs(context.scoring_hand) do
                sum = playing_card.base.nominal + sum
            end

            if sum % 2 == 0 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            else
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            end

            return {
               mult = card.ability.extra.mult,
               chips = card.ability.extra.chips,
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.mult_mod, card.ability.extra.chip_mod, card.ability.extra.mult, card.ability.extra.chips } }
	end
}

print("Antsy jokers loaded...")