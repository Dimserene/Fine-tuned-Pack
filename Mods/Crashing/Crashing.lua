--- STEAMODDED HEADER
--- MOD_NAME: Crashing
--- MOD_ID: Crashing
--- MOD_AUTHOR: [WilsontheWolf]
--- MOD_DESCRIPTION: Press "[" to Crash
--- VERSION: 2.0
----------------------------------------------
------------MOD CODE -------------------------
local mod = SMODS.current_mod;
if not mod then -- Older Steamodded
	mod = {}
end


local keyHandler = Controller.key_press_update;
function Controller:key_press_update(key, dt)
	mod.debug_info = { version = "2.0" }
	if(key == '[') then 
		mod.debug_info.Note = "User pressed ["
		error('Funny Crash go BRRRRRRRRRRR')
	end
	if(key == ']') then
		mod.debug_info.Note = "User pressed ]"
	 	error('I am a big scary error\n'..string.rep('Hi mom\n', 50))
	end
	return keyHandler(self, key, dt)
end

----------------------------------------------
------------MOD CODE END----------------------
