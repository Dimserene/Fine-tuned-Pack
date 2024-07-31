--- STEAMODDED HEADER
--- MOD_NAME: Less Intrusive Stickers
--- MOD_ID: Less_N_S
--- MOD_AUTHOR: [FabianPEKS]
--- MOD_DESCRIPTION: Do the stickers the game uses feel annoyingly large? well i think so. so i did a redesign so they aren't massively large.

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.Less_N_S()

    local small_sticker = SMODS.findModByID("Less_N_S")
    local intrusive_sticker = SMODS.Sprite:new("stickers", small_sticker.path, "stickers.png", 71, 95, "asset_atli")
    
    intrusive_sticker:register()
end

----------------------------------------------
------------MOD CODE END----------------------
