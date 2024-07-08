--- STEAMODDED HEADER

--- MOD_NAME: Blanks
--- MOD_ID: blanks
--- MOD_AUTHOR: [jenwalter666]
--- MOD_DESCRIPTION: Adds blank consumable cards, which randomise when used.
--- PRIORITY: 0
--- BADGE_COLOR: 8c8c8c
--- PREFIX: blanks
--- VERSION: 0.0.2a
--- LOADER_VERSION_GEQ: 1.0.0

local function deepCopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
  
    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in pairs(obj) do res[deepCopy(k, s)] = deepCopy(v, s) end
    return setmetatable(res, getmetatable(obj))
end

SMODS.Atlas {
	key = "modicon",
	path = "blanks_avatar.png",
	px = 34,
	py = 34
}

SMODS.Atlas {
	key = "blankcards",
	path = "blanks_cards.png",
	px = 71,
	py = 95
}

local blanks = {
	'Planet',
	'Spectral',
	'Tarot'
}

for k, v in pairs(blanks) do
	SMODS.Consumable {
		key = 'blanks_' .. v,
		loc_txt = {
			name = 'Blank ' .. v,
			text = {
				"Transforms into a random",
				"{C:dark_edition}" .. v .. "{} card on use",
				"Resultant card is then",
				"added to the {C:attention}consumables tray{}",
				"{C:inactive}(Must have room){}",
				"{C:inactive,s:0.7}(May potentially become itself){}"
			},
		},
		set = v,
		pos = {x = k-1, y = 0},
		atlas = 'blankcards',
		config = {},
		discovered = true,
		cost = 2,
		can_use = function(self, card)
			return true
		end,
		use = function(self, card, area, copier)
			local speed = G.SETTINGS.GAMESPEED
			local copy = deepCopy(G.P_CENTERS) --doing this to avoid overwriting the original table
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
			return true end }))
			delay(0.4)
			--scale the delays to match up with game speed to keep the animation speed normal, but reduce the number of iterations so it doesn't take as long
			local iterations = math.min(30, math.max(3, math.ceil(math.random(5,15) / speed)))
			local mod = (15 / iterations / 50) * speed
			local ability = copy[pseudorandom_element(G.P_CENTER_POOLS[v], pseudoseed('blanks_' .. string.lower(v))).key]
			for i = 1, iterations do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2 + (mod*i), func = function()
					play_sound('card1')
					card:juice_up(0.3, 0.3)
					card:flip()
				return true end }))
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2 + (mod*i), func = function()
					play_sound('card1')
					card:flip()
					card:juice_up(0.3, 0.3)
					card:set_ability(ability, true)
					if i < iterations then
						ability = copy[pseudorandom_element(G.P_CENTER_POOLS[v], pseudoseed('blanks_' .. string.lower(v))).key]
					end
				return true end }))
			end
			delay(0.1)
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4 * speed, func = function()
				play_sound('timpani')
				if card then
					card:juice_up(0.3, 0.5)
				end
			return true end }))
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1 * speed, func = function()
				if card then
						delay(1)
						if #G.consumeables.cards < G.consumeables.config.card_limit then
							local card2 = create_card(v, G.consumeables, nil, nil, nil, nil, nil, 'blank')
							card2:set_ability(ability, true)
							card2:add_to_deck()
							G.consumeables:emplace(card2)
						else
							attention_text({
								text = localize('k_no_room_ex'),
								scale = 1.3, 
								hold = 1.4,
								major = card,
								backdrop_colour = G.C.SECONDARY_SET.Tarot,
								align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
								offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
								silent = true
							})
							card:juice_up(0.3, 0.3)
						end
						delay(1)
				end
			return true end }))
		end	
	}
end