--- STEAMODDED HEADER
--- MOD_NAME: Modpack Decks
--- MOD_ID: ModpackDecks
--- MOD_AUTHOR: [Dimserene]
--- MOD_DESCRIPTION: Decks for modpack
--- DISPLAY_NAME: Modpack Decks
--- PREFIX: mpd
--- DEPENDENCIES: [Steamodded>=1.0.0-ALPHA]

SMODS.Atlas{
    key = "enhancers",
    path = "enhancers.png",
    px = 71,
    py = 95
}

    --- Frontier Deck

        SMODS.Back{
            key = "b_moon_base",
            name = "Frontier Deck",
            pos = {x = 0, y = 0},
            loc_txt = {
                name = "Frontier Deck",
                text = {
                    "Start run with",
                    "an {C:eternal}Eternal{} and {C:dark_edition}Negative{} {C:attention}Moon Base",
                    "Require SDM_0'S Stuff"
                }
            },
            apply = function(back)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        add_joker("j_sdm_moon_base", "negative", true, true)
                        return true
                    end
                }))
            end,
            atlas = "enhancers"
        }
        atlas = "enhancers"

return

----------------------------------------------
------------MOD CODE END----------------------