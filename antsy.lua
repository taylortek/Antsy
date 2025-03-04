--[[
   The following code is very scuffed
]]

-- Register config
local config = SMODS.current_mod.config

-- Store mod path (I saw cryptid do it)
local mod_path = "" .. SMODS.current_mod.path

-- Register an atlas for jokers to use
SMODS.Atlas {
    key = 'antsyjokeratlas',
    path = 'jokeratlas.png',
    px = 71,
    py = 95
}

-- Register an atlas for decks to use
SMODS.Atlas {
    key = 'antsybackatlas',
    path = 'backatlas.png',
    px = 71,
    py = 95
}

-- Function to check if item is an antsy item
function is_antsy_item(str)
    if (string.sub(str,1,3) == "tag") then
        return string.sub(str,5,9) == "antsy"
    else
        return string.sub(str,3,7) == "antsy"
    end
end

-- This is super jank, but basically it loads all the files from the Items directory and runs them T-T
-- I have no idea how this affects performance vs just having all the code in one file
local files = NFS.getDirectoryItems(mod_path .. "Items")
for _,file in ipairs(files) do
    SMODS.load_file("Items/" .. file)()
end

-- Create G.GAME.events when starting a run, so there's no errors (I stole this from cryptid, and I don't know what it does)
local gigo = Game.init_game_object
function Game:init_game_object()
	local g = gigo(self)
	g.events = {}
	return g
end

G.C.ANTSY_PINK = HEX("FFD9EE")
G.C.ANTSY_BLUE = HEX("ACECF7")

G.C.ANTSY_SPLASH1 = HEX("4400ff")
G.C.ANTSY_SPLASH2 = HEX("ff00d4")

-- Change splash screen
function menu_injection()
    local splash_args = {mid_flash = change_context == 'splash' and 1.6 or 0.}

    if config.custom_menu then
        G.SPLASH_BACK:define_draw_steps({{
            shader = 'splash',
            send = {
                {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
                {name = 'vort_speed', val = config.vort_speed},
                {name = 'colour_1', ref_table = G.C, ref_value = 'ANTSY_SPLASH2'},
                {name = 'colour_2', ref_table = G.C, ref_value = 'ANTSY_SPLASH1'},
                {name = 'mid_flash', ref_table = splash_args, ref_value = 'mid_flash'},
                {name = 'vort_offset', val = 0},
            }}})
        else 
            G.SPLASH_BACK:define_draw_steps({{
                shader = 'splash',
                send = {
                    {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
                    {name = 'vort_speed', val = config.vort_speed},
                    {name = 'colour_1', ref_table = G.C, ref_value = 'RED'},
                    {name = 'colour_2', ref_table = G.C, ref_value = 'BLUE'},
                    {name = 'mid_flash', ref_table = splash_args, ref_value = 'mid_flash'},
                    {name = 'vort_offset', val = 0},
                }}})
        end
end

local oldfunc = Game.main_menu
Game.main_menu = function(change_context)
    local ret = oldfunc(change_context)
    -- adds a Dominic Assassin joker to the main menu
    if config.show_antsy_card then
        local newcard = create_card('Joker',G.title_top, nil, nil, nil, nil, 'j_antsy_demonic_assassin', 'elial1')

        -- recenter the title
        G.title_top.T.w = G.title_top.T.w*1.7675
        G.title_top.T.x = G.title_top.T.x - 0.8
        G.title_top:emplace(newcard)
        -- make the card look the same way as the title screen Ace of Spades
        newcard.T.w = newcard.T.w * 1.1*1.2
        newcard.T.h = newcard.T.h *1.1*1.2
        newcard.no_ui = true
    end

    menu_injection() 
    return ret
end

-- There's no world where this is ok
local old_func = G.draw
G.draw = function ()
    local ret = old_func(G)
    love.graphics.print('Memory actually used (in mb): ' .. string.format("%.5f",collectgarbage('count')/1000), 10,50)
    return ret
end

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {
        r = 0.1,
        minw = 5,
        minh = 5,
        align = "cm",
        padding = 0.2,
        colour = G.C.BLACK
	}, nodes = {
        create_toggle({label = '*Show Antsy title card', ref_table = config, ref_value = 'show_antsy_card'}),
        create_toggle({label = 'Custom Menu colors', ref_table = config, ref_value = 'custom_menu'}),
        create_slider({label = 'Vortex Speed', ref_table = config, ref_value = 'vort_speed', decimal_places = 1, w=3, max=2}),
        UIBox_button({label = {'Apply'}, button = "apply_antsy_settings"}),
        {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.T, config={text = "*requires restart", scale = 0.2, colour = G.C.UI.TEXT_LIGHT}}
        }},
	}}
end

G.FUNCS.apply_antsy_settings = function(e)
    menu_injection()
    SMODS.save_mod_config(config)
end