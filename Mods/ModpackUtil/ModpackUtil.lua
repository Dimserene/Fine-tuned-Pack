--- STEAMODDED HEADER
--- MOD_NAME: Dimserene's Modpack Utility
--- MOD_ID: Modpack_Util
--- MOD_AUTHOR: [Dimserene]
--- MOD_DESCRIPTION: Dimserene's Modpack Utility
--- VERSION: Fine-tuned
--- PRIORITY: -999999999999999999999999
----------------------------------------------
------------MOD CODE -------------------------

local lovely = require("lovely")
local nativefs = require("nativefs")

if SMODS.Atlas then
  SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
  })
end


-- read version.txt
local version = nativefs.read(lovely.mod_dir .. "/ModpackUtil/version.txt")

local updated = os.date("!%Y/%m/%d %H:%M:%S", love.filesystem.getLastModified(lovely.mod_dir .. "/ModpackUtil/version.txt"))


local MODPACK_VERSION = "Dimserene's Modpack - Fine-tuned" .. "\nCurrent Version: " .. version .. "   Game Started: " .. updated


local gameMainMenuRef = Game.main_menu
function Game:main_menu(change_context)
	gameMainMenuRef(self, change_context)
	UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = {
				align = "cm",
				colour = G.C.UI.TRANSPARENT_DARK
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						scale = 0.3,
						text = MODPACK_VERSION,
						colour = G.C.UI.TEXT_LIGHT
					}
				}
			}
		},
		config = {
			align = "tri",
			bond = "Weak",
			offset = {
				x = 0,
				y = 0.6
			},
			major = G.ROOM_ATTACH
		}
	})
end

----------------------------------------------
------------MOD CODE END----------------------