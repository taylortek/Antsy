SMODS.Voucher {
    key = "test",
    loc_txt = {name = "Employee Discount", text = {"+1 joker slot for every", "Antsy Joker"}},
    config = {
        extra = {
            antsy_cards = 0,
            jokers = 0
        }
    },
    -- This will check for changes in jokers EVERY FRAME. I don't know how to (or if I even can) fix this!
    update = function(self, card, context)
        local antsy_cards = 0
        -- My best attempt at saving frames, but I'm sure this is still a perfomance hit
        if G.jokers ~= nil then
        if card.ability.extra.jokers ~= #G.jokers.cards then
            card.ability.extra.jokers = #G.jokers.cards
            for _,joker in ipairs(G.jokers.cards) do
                if is_antsy_item(joker.ability.name) and joker.ability.name ~= "j_antsy_debris" then
                    antsy_cards = antsy_cards + 1
                end
            end
            if antsy_cards ~= card.ability.extra.antsy_cards then
                G.jokers.config.card_limit = G.jokers.config.card_limit + (antsy_cards - card.ability.extra.antsy_cards)
                card.ability.extra.antsy_cards = antsy_cards
            end
        end
    end
    end
}