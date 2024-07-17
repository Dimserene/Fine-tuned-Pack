--- STEAMODDED HEADER
--- MOD_NAME: Bonus Blinds
--- MOD_ID: BB
--- PREFIX: bb
--- MOD_AUTHOR: [mathguy]
--- MOD_DESCRIPTION: Bonus Blinds
--- VERSION: 1.1.0
----------------------------------------------
------------MOD CODE -------------------------

---------------------------------------------------

function disco_jokers()
    if #G.jokers.cards > 1 then
        local wiggle = {}
        for i = #G.jokers.cards, 2, -1 do
            local j = math.ceil(pseudorandom(pseudoseed('disco'))*i)
            local e_swap = true
            if G.jokers.cards[j].ability.eternal and not (G.jokers.cards[i].config.center.eternal_compat and not G.jokers.cards[i].ability.perishable) then
                e_swap = false
            end
            if G.jokers.cards[i].ability.eternal and not (G.jokers.cards[j].config.center.eternal_compat and not G.jokers.cards[j].ability.perishable) then
                e_swap = false
            end
            if (not not G.jokers.cards[i].ability.eternal) == (not not G.jokers.cards[j].ability.eternal) then
                e_swap = false
            end
            local p_swap = true
            if G.jokers.cards[j].ability.perishable and not (G.jokers.cards[i].config.center.perishable_compat and not G.jokers.cards[i].ability.eternal) then
                p_swap = false
            end
            if G.jokers.cards[i].ability.perishable and not (G.jokers.cards[j].config.center.perishable_compat and not G.jokers.cards[j].ability.eternal) then
                p_swap = false
            end
            if (not not G.jokers.cards[i].ability.perishable) == (not not G.jokers.cards[j].ability.perishable) then
                p_swap = false
            end
            local ep_swap = true
            if G.jokers.cards[j].ability.eternal and not G.jokers.cards[i].config.center.eternal_compat then
                ep_swap = false
            end
            if G.jokers.cards[i].ability.eternal and not G.jokers.cards[j].config.center.eternal_compat then
                ep_swap = false
            end
            if G.jokers.cards[j].ability.perishable and not G.jokers.cards[i].config.center.perishable_compat then
                ep_swap = false
            end
            if G.jokers.cards[i].ability.perishable and not G.jokers.cards[j].config.center.perishable_compat then
                ep_swap = false
            end
            if ((not not G.jokers.cards[i].ability.perishable) == (not not G.jokers.cards[j].ability.perishable)) and 
            ((not not G.jokers.cards[i].ability.eternal) == (not not G.jokers.cards[j].ability.eternal)) then
                ep_swap = false
            end
            if e_swap or p_swap or ep_swap then
                local pool = {}
                if e_swap then
                    table.insert(pool, 'e')
                end
                if p_swap then
                    table.insert(pool, 'p')
                end
                if ep_swap then
                    table.insert(pool, 'ep')
                end
                local swap = pseudorandom_element(pool, pseudoseed('disco'))
                if (swap == 'e') or (swap == 'ep') then
                    local a, b = G.jokers.cards[i].ability.eternal, G.jokers.cards[j].ability.eternal
                    G.jokers.cards[i].ability.eternal = b
                    G.jokers.cards[j].ability.eternal = a
                    wiggle[i] = true
                    wiggle[j] = true
                end
                if (swap == 'p') or (swap == 'ep') then
                    local a, b = G.jokers.cards[i].ability.perishable, G.jokers.cards[j].ability.perishable
                    local c, d = G.jokers.cards[i].ability.perish_tally, G.jokers.cards[j].ability.perish_tally
                    G.jokers.cards[i].ability.perishable = b
                    G.jokers.cards[i].ability.perish_tally = d
                    G.jokers.cards[j].ability.perishable = a
                    G.jokers.cards[j].ability.perish_tally = c
                    wiggle[i] = true
                    wiggle[j] = true
                end
            end
        end 
        local rental_count = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.rental == true then
                rental_count = rental_count + 1
            end
        end
        if (rental_count ~= 0) and (rental_count ~= #G.jokers.cards) then
            rental_count = #G.jokers.cards - rental_count
            local pool = {}
            for i = 1, #G.jokers.cards do
                pool[i] = true
            end
            for i = 1, rental_count do
                local val, key = pseudorandom_element(pool, pseudoseed('disco'))
                pool[key] = nil
            end
            for i = 1, #G.jokers.cards do
                if (pool[i] == true) and (G.jokers.cards[i].ability.rental ~= true) then
                    G.jokers.cards[i]:set_rental(true)
                    wiggle[i] = true
                elseif (pool[i] ~= true) and (G.jokers.cards[i].ability.rental == true) then
                    G.jokers.cards[i]:set_rental(nil)
                    wiggle[i] = true
                end
            end
        end
        for i, j in pairs(wiggle) do
            G.jokers.cards[i]:juice_up()
        end
        if #wiggle > 0 then
            play_sound('card1', 1)
        end
    end
end

local bonusType = SMODS.ConsumableType {
    key = 'Bonus',
    primary_colour = G.C.RED,
    secondary_colour = G.C.RED,
    loc_txt = {
        name = 'Bonus Blind',
        collection = 'Bonus Blinds',
        undiscovered = {
            name = 'Undiscovered Bonus',
            text = { 'idk stuff ig' },
        }
    },
    collection_rows = { 6, 6 },
    shop_rate = 2,
    rarities = {
        {key = 'Common', rate = 100},
        {key = 'Uncommon', rate = 25},
        {key = 'Rare', rate = 5},
        {key = 'Legendary', rate = 1},
    },
    default = "c_bb_bonus"
}

SMODS.Bonus = SMODS.Consumable:extend {
    set = 'Bonus',
    set_badges = function(self, card, badges)
        local colours = {
            Common = HEX('FE5F55'),
            Uncommon =  HEX('8867a5'),
            Rare = HEX("fda200"),
            Legendary = {0,0,0,1}
        }
        local len = string.len(self.rarity)
        local size = 1.3 - (len > 5 and 0.02 * (len - 5) or 0)
        badges[#badges + 1] = create_badge(self.rarity, colours[self.rarity], nil, size)
    end,
    can_use = function(self, card)
        return ((not not G.blind_select) and (G.STATE ~= G.STATES.BUFFOON_PACK) and (G.STATE ~= G.STATES.TAROT_PACK) and (G.STATE ~= G.STATES.SPECTRAL_PACK) and (G.STATE ~= G.STATES.STANDARD_PACK) and (G.STATE ~= G.STATES.PLANET_PACK)) or ((card.area == G.pack_cards) and (#G.consumeables.cards < (G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0))))
    end,
    use = function(self, card, area, copier)
        if area == G.pack_cards then
            local card2 = copy_card(card)
            G.pack_cards:remove_card(card)
            card:remove()
            G.consumeables:emplace(card2)
        else
            self:use2(card, area, copier)
        end
    end,
    cost = 2
}

SMODS.Atlas({ key = "mystery", atlas_table = "ASSET_ATLAS", path = "mystery.png", px = 71, py = 95})

SMODS.Atlas({ key = "another", atlas_table = "ASSET_ATLAS", path = "bonus.png", px = 71, py = 95})

SMODS.Atlas({ key = "loops", atlas_table = "ASSET_ATLAS", path = "loop.png", px = 71, py = 95})

SMODS.Atlas({ key = "bonus_tags", atlas_table = "ASSET_ATLAS", path = "tags.png", px = 34, py = 34})

SMODS.Atlas({ key = "vouchery", atlas_table = "ASSET_ATLAS", path = "vouchers.png", px = 71, py = 95})

SMODS.Atlas({ key = "boostery", atlas_table = "ASSET_ATLAS", path = "boosters.png", px = 71, py = 95})

SMODS.Atlas({ key = "jokery", atlas_table = "ASSET_ATLAS", path = "jokers.png", px = 71, py = 95})

SMODS.Atlas({ key = "decks", atlas_table = "ASSET_ATLAS", path = "Backs.png", px = 71, py = 95})

local unknown = SMODS.UndiscoveredSprite {
    key = 'Bonus',
    atlas = 'mystery',
    pos = {x = 0, y = 0}
}

--- Common (10)

SMODS.Bonus {
    key = 'extra',
    loc_txt = {
        name = "Bonus Blind",
        text = {
            "Charges {C:money}$#2#{}",
            "to play {C:blue}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 0, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        if G.P_BLINDS == nil then
            card.ability.the_blind = 'bl_small'
            card.ability.reward = {dollars = 1}
        else
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            card.ability.the_blind = blind
            card.ability.reward = {dollars = math.floor(1.5*G.P_BLINDS[blind].dollars)}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, card.ability.reward.dollars}}
    end,
    use2 = function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {none = 1})
        ease_dollars(-card.ability.reward.dollars)
    end,
    can_use = function(self, card)
        return ((not not G.blind_select) and ((G.GAME.dollars  - G.GAME.bankrupt_at) >= card.ability.reward.dollars) and (G.STATE ~= G.STATES.BUFFOON_PACK) and (G.STATE ~= G.STATES.TAROT_PACK) and (G.STATE ~= G.STATES.SPECTRAL_PACK) and (G.STATE ~= G.STATES.STANDARD_PACK) and (G.STATE ~= G.STATES.PLANET_PACK)) or ((card.area == G.pack_cards) and (#G.consumeables.cards < (G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0))))
    end
}

SMODS.Bonus {
    key = 'needy',
    loc_txt = {
        name = "Needy Blind",
        text = {
            "Play a {C:attention}Boss Blind{}",
            "with only {C:blue}#1#{} Hand"
        }
    },
    atlas = "another",
    pos = {x = 2, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.start_hands = 1
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.start_hands}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and (i ~= 'bl_needle') and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {hands = card.ability.start_hands})
    end
}

SMODS.Bonus {
    key = 'sail',
    loc_txt = {
        name = "Sailing Blind",
        text = {
            "Play a {C:attention}Boss Blind{}",
            "with {C:red}#1#{} Discards"
        }
    },
    atlas = "another",
    pos = {x = 3, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.start_discards = 0
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.start_discards}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and (i ~= 'bl_water') and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {discards = card.ability.start_discards})
    end
}

SMODS.Bonus {
    key = 'locked',
    loc_txt = {
        name = "Locked Blind",
        text = {
            "Play {C:blue}#1#{} with",
            "{C:attention}-#2#{} Hand Size"
        }
    },
    atlas = "another",
    pos = {x = 9, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_big'
        card.ability.hand_size_sub = 2
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, card.ability.hand_size_sub}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {hand_size = -card.ability.hand_size_sub})
    end
}

SMODS.Bonus {
    key = 'fixed',
    loc_txt = {
        name = "Fixed Blind",
        text = {
            "All {C:attention}Jokers{} become {C:attention}Pinned{}",
            "then play {C:blue}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 11, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_small'
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {pin_jokers = true})
    end
}

SMODS.Bonus {
    key = 'combo',
    loc_txt = {
        name = "Combo Blind",
        text = {
            "Play {C:blue}#1#{}. All {C:attention}Jokers{}",
            "{C:attention}face down{} this blind."
        }
    },
    atlas = "another",
    pos = {x = 0, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_final_heart'
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_crimson', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {flip_jokers = true})
    end
}

SMODS.Bonus {
    key = 'brick',
    loc_txt = {
        name = "Brick Blind",
        text = {
            "Play a {C:attention}Boss Blind{}",
            "with {C:blue}X#1# Blind Size{}"
        }
    },
    atlas = "another",
    pos = {x = 3, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.reward = {blind_mult = 2}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.reward.blind_mult}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, card.ability.reward)
    end
}

SMODS.Bonus {
    key = 'watching',
    loc_txt = {
        name = "Watching Blind",
        text = {
            "Play {C:green}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 5, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_bb_watch'
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_watch', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {none = true})
    end
}

SMODS.Bonus {
    key = 'sky',
    loc_txt = {
        name = "Sky-High Blind",
        text = {
            "Play {C:blue}#1#{} with {C:attention}double{}",
            "your {C:attention}best hand{} added to {C:blue}Blind Size{}",
            "{C:inactive}(Best Hand:{}{C:attention} #2#{}{C:inactive}){}"
        }
    },
    atlas = "another",
    pos = {x = 7, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_small'
    end,
    loc_vars = function(self, info_queue, card)
        local best = (G.GAME and G.GAME.round_scores and G.GAME.round_scores.hand.amt) or 0
        best = number_format(best)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, best}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {blind_size_mod = ((G.GAME and G.GAME.round_scores and (G.GAME.round_scores.hand.amt * 2)) or 0)})
    end
}

SMODS.Bonus {
    key = 'cruel',
    loc_txt = {
        name = "Cruel Blind",
        text = {
            "Play a {C:attention}Boss Blind{} with",
            "at least {C:attention}#1#{} empty {C:attention}Joker Slot{}",
            "{C:inactive}(can destroy jokers){}"
        }
    },
    atlas = "another",
    pos = {x = 8, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.emp_jkr = 1
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.emp_jkr}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {emp_jkr = card.ability.emp_jkr})
    end
}

--- Uncommon (8)

SMODS.Bonus {
    key = 'redo',
    loc_txt = {
        name = "Redo Blind",
        text = {
            "Defeat {C:purple}#1#{} with ",
            "{C:blue}X3 Blind Size{} to get a {C:attention}#2#{}"
        }
    },
    atlas = "another",
    pos = {x = 1, y = 0},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_final_vessel'
        card.ability.reward = {tags = {'tag_boss'}, blind_mult = 3}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_violet', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, localize{type ='name_text', key = card.ability.reward.tags[1], set = 'Tag'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, card.ability.reward)
    end
}

SMODS.Bonus {
    key = 'broken',
    loc_txt = {
        name = "Broken Blind",
        text = {
            "{C:green}#1# in #2#{} chance to",
            "play a {C:blue}#3#{}"
        }
    },
    atlas = "another",
    pos = {x = 5, y = 0},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_small'
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal,2,localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        if pseudorandom("broken") < G.GAME.probabilities.normal/2 then
            bonus_selection(card.ability.the_blind, {none = 1})
        else
            G.GAME.pool_flags.failed_broken_blind = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
            delay(0.6)
        end
    end
}

SMODS.Bonus {
    key = 'spoiler',
    loc_txt = {
        name = "Spoiler Blind",
        text = {
            "Play {C:attention}Ante #1#s{} {C:attention}Showdown Blind{}",
            "on this {C:attention}Ante{}"
        }
    },
    atlas = "another",
    pos = {x = 8, y = 0},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        local showdown = (G.GAME.round_resets.ante and (G.GAME.win_ante + math.max(0, math.floor(G.GAME.round_resets.ante / G.GAME.win_ante) * G.GAME.win_ante))) or 8 
        return {vars = {showdown}}
    end,
    use2 =function(self, card, area, copier)
        local showdown = G.GAME.win_ante + math.max(0, math.floor(G.GAME.round_resets.ante / G.GAME.win_ante) * G.GAME.win_ante)
        local blind = ""
        if G.GAME.round_resets.ante == showdown then
            blind = G.GAME.round_resets.blind_choices.Boss
        elseif not G.GAME.forced_blinds or G.GAME.forced_blinds[showdown] == nil then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and j.boss.showdown and not G.GAME.banned_keys[i] and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local preused = {}
            local min_use = 100
            for k, v in pairs(rngpick) do
                preused[v] = G.GAME.bosses_used[v]
                if preused[v] <= min_use then 
                    min_use = preused[v]
                end
            end
            for k, v in pairs(preused) do
                if preused[k] then
                    if preused[k] <= min_use then 
                        preused[k] = nil
                    end
                end
            end
            rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and j.boss.showdown and not G.GAME.banned_keys[i] and not preused[i] then
                    table.insert(rngpick, i)
                end
            end
            blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            if G.GAME.forced_blinds == nil then
                G.GAME.forced_blinds = {}
            end
            G.GAME.forced_blinds[showdown] = blind
        else
            blind = G.GAME.forced_blinds[showdown]
        end
        bonus_selection(blind, {none = true})
    end
}

SMODS.Bonus {
    key = 'meta',
    loc_txt = {
        name = "Meta Blind",
        text = {
            "Activate a {C:red}Common Bonus Blind{}. Upon",
            "blind defeat, get an {C:attention}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 2, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.reward = {tags = {'tag_bb_ironic'}}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 't_irony', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'p_jumbo_bl', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.reward.tags[1], set = 'Tag'}}}
    end,
    use2 =function(self, card, area, copier)
        local commons = {'extra', 'needy', 'sail', 'locked', 'fixed', 'combo', 'brick', 'watching', 'sky'}
        local common = pseudorandom_element(commons, pseudoseed('meta'))
        if common == 'extra' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {tags = card.ability.reward.tags})
            ease_dollars(-math.floor(1.5*G.P_BLINDS[blind].dollars))
        elseif common == 'needy' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus and (i ~= 'bl_needle') then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {hands = 1, tags = card.ability.reward.tags})
        elseif common == 'sail' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and (i ~= 'bl_water') and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {discards = 0, tags = card.ability.reward.tags})
        elseif common == 'locked' then
            bonus_selection('bl_big', {hand_size = -2, tags = card.ability.reward.tags})
        elseif common == 'fixed' then
            bonus_selection('bl_small', {pin_jokers = true, tags = card.ability.reward.tags})
        elseif common == 'combo' then
            bonus_selection('bl_final_heart', {flip_jokers = true, tags = card.ability.reward.tags})
        elseif common == 'brick' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {blind_mult = 2, tags = card.ability.reward.tags})
        elseif common == 'watching' then
            bonus_selection('bl_bb_watch', {tags = card.ability.reward.tags})
        elseif common == 'sky' then
            local best = (G.GAME and G.GAME.round_scores and G.GAME.round_scores.hand.amt) or 0
            bonus_selection('bl_small', {blind_size_mod = best * 2, tags = card.ability.reward.tags})
        end
    end
}

SMODS.Bonus {
    key = 'disco',
    loc_txt = {
        name = "Disco Blind",
        text = {
            "Play {C:blue}#1#{}. Shuffle",
            "{C:attention}Stickers{} each {C:blue}hand{}"
        }
    },
    atlas = "another",
    pos = {x = 4, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_final_bell'
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_cerulean', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {disco = true})
    end
}

SMODS.Bonus {
    key = 'rewind',
    loc_txt = {
        name = "Rewind Blind",
        text = {
            "Play the last {C:attention}blind{}",
            "with {C:blue}X2 Hands{}"
        }
    },
    atlas = "another",
    pos = {x = 6, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    use2 = function(self, card, area, copier)
        local blind = G.GAME.last_blind and G.GAME.last_blind.key
        bonus_selection(blind, {double_hands = true})
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Bonus.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local blind = (G.GAME.last_blind and G.GAME.last_blind.key) or nil
        local last_blind_done = blind and localize{type = 'name_text', key = blind, set = 'Blind'} or localize('k_none')
        local colour = (not blind) and G.C.RED or G.C.BLUE
        desc_nodes[#desc_nodes+1] = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_blind_done..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
    end,
    can_use = function(self, card)
        return ((not not G.blind_select) and (G.GAME.last_blind and not not G.GAME.last_blind.key) and (G.STATE ~= G.STATES.BUFFOON_PACK) and (G.STATE ~= G.STATES.TAROT_PACK) and (G.STATE ~= G.STATES.SPECTRAL_PACK) and (G.STATE ~= G.STATES.STANDARD_PACK) and (G.STATE ~= G.STATES.PLANET_PACK)) or ((card.area == G.pack_cards) and (#G.consumeables.cards < (G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0))))
    end
}

SMODS.Bonus {
    key = 'patch',
    loc_txt = {
        name = "Patched Blind",
        text = {
            "Defeat a {C:attention}Blind{}",
            "for a {C:attention}reward{}"
        }
    },
    atlas = "another",
    pos = {x = 9, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    use2 = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if not j.boss or not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {rand_reward = true})
    end,
    in_pool = function(self)
        return (not not G.GAME.pool_flags.failed_broken_blind), {allow_duplicates = false}
    end
}

SMODS.Bonus {
    key = 'dice',
    loc_txt = {
        name = "Dice Blind",
        text = {
            "Defeat a {C:attention}Boss Blind{} for",
            "{C:attention}#1#{} free {C:green}rerolls{} next shop",
        }
    },
    atlas = "another",
    pos = {x = 10, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.reward = {rerolls = 5}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.reward.rerolls}}
    end,
    use2 = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {free_rerolls = card.ability.reward.rerolls})
    end
}

--- Rare (3)

SMODS.Bonus {
    key = 'luck',
    loc_txt = {
        name = "Lucky Blind",
        text = {
            "Defeat a {C:attention}Blind{} with ",
            "{C:blue}#1#{} Hand and {C:red}#2#{} Discard",
            "to get #3# {C:attention}#4#s{}"
        }
    },
    atlas = "another",
    pos = {x = 6, y = 0},
    rarity = 'Rare',
    cost = 5,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.start_discards = 1
        card.ability.start_hands = 1
        card.ability.reward = {tags = {'tag_voucher', 'tag_voucher'}}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'tag_voucher', set = 'Tag'}
        return {vars = {card.ability.start_hands, card.ability.start_discards, 2, localize{type ='name_text', key = card.ability.reward.tags[1], set = 'Tag'}}}
    end,
    use2 = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if (not j.boss or not j.boss.showdown) and not (j.boss and j.boss.bonus) then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {hands = card.ability.start_hands, discards = card.ability.start_discards, tags = card.ability.reward.tags })
    end
}

SMODS.Bonus {
    key = 'magma',
    loc_txt = {
        name = "Magma Blind",
        text = {
            "Defeat {C:blue}#1#{} to",
            "{C:attention}destroy{} cards {C:attention}held in hand{}"
        }
    },
    atlas = "another",
    pos = {x = 7, y = 0},
    rarity = 'Rare',
    cost = 5,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_hook'
        card.ability.reward = {burn_hand = true}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_snatch', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 = function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, card.ability.reward)
    end,
}

SMODS.Bonus {
    key = 'lottery',
    loc_txt = {
        name = "Lottery Blind",
        text = {
            "Add {C:red}+#1#{} Mult to {C:attention}#2#{} random",
            "{C:attention}playing card{} then play {C:attention}#3#{}"
        }
    },
    atlas = "another",
    pos = {x = 1, y = 1},
    cost = 3,
    rarity = 'Rare',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_flint'
        card.ability.mult = 25
        card.ability.cards = 1
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_rocky', set = 'Other'}
        return {vars = {card.ability.mult, card.ability.cards, localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {lotto = {amount = card.ability.mult, cards = card.ability.cards}})
    end
}

SMODS.Bonus {
    key = 'hankercheif',
    loc_txt = {
        name = "Hankercheif Blind",
        text = {
            "Play {C:attention}#1#{}. Earn {C:money}$1{} when",
            "a playing card is scored",
        }
    },
    atlas = "another",
    pos = {x = 11, y = 1},
    rarity = 'Rare',
    cost = 5,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_ox'
        card.ability.reward = {dollars_score = 1}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'blind_ox', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 = function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, card.ability.reward)
    end
}

--- Legendary (2)

SMODS.Bonus {
    key = 'champion',
    loc_txt = {
        name = "Champion Blind",
        text = {
            "{C:attention}-#1#{} Antes then play",
            "a {C:blue}Showdown Blind{}"
        }
    },
    atlas = "another",
    pos = {x = 4, y = 0},
    rarity = 'Legendary',
    cost = 7,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.remove_ante = 2
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.remove_ante}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {ante_mod = -card.ability.remove_ante})
    end
}

SMODS.Bonus {
    key = 'natural',
    loc_txt = {
        name = "Supernatural Blind",
        text = {
            "Play {C:green}The Serpent{}. All",
            "{C:attention}Jokers{} are {C:attention}Eternal{} for",
            "this blind. {C:attention}+1{} {C:dark_edition}Negative{}",
            "{C:spectral}Spectral{} each {C:blue}hand{}."
        }
    },
    atlas = "another",
    pos = {x = 10, y = 0},
    rarity = 'Legendary',
    cost = 7,
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_snake', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        return {vars = {}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection('bl_serpent', {eternal_round = true, spectrals = true})
    end
}

-----------------

SMODS.Spectral {
    key = 'loop',
    loc_txt = {
        name = "Loop",
        text = {
            "Create a random",
            "{C:red}Bonus Blind{}"
        }
    },
    atlas = "loops",
    pos = {x = 0, y = 0},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local card = create_card("Bonus", G.consumeables)
            card:add_to_deck()
            G.consumeables:emplace(card)
            card:juice_up(0.3, 0.5)
            return true
        end}))
        delay(0.6)
    end,
    can_use = function(self, card)
        return (#G.consumeables.cards < G.consumeables.config.card_limit) or (card.area == G.consumeables)
    end
}

SMODS.Tag {
    key = 'ironic',
    atlas = 'bonus_tags',
    loc_txt = {
        name = "Ironic Tag",
        text = {
            "Gives a free",
            "{C:red}Jumbo Blind Pack"
        }
    },
    pos = {x = 0, y = 0},
    apply = function(tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.RED,function() 
                local key = 'p_bb_blind_jumbo_1'
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue+1] = {key = 'p_jumbo_bl', set = 'Other'}
        return {}
    end,
    config = {type = 'new_blind_choice'}
}

SMODS.Voucher {
    key = 'bonus1',
    loc_txt = {
        name = "Blind Merchant",
        text = {
            "{C:red}Bonus Blinds{} cards appear",
            "{C:attention}#1#X{} more frequently",
            "in the shop"
        }
    },
    config = {rate = 1.5},
    atlas = 'vouchery',
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {1.5}}
    end,
    redeem = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            if G.GAME.selected_back.name == "Ante Deck" then
                G.GAME.bonus_rate = 10*self.config.rate
            else
                G.GAME.bonus_rate = 2*self.config.rate
            end
        return true end }))
    end
}

SMODS.Voucher {
    key = 'bonus2',
    loc_txt = {
        name = "Blind Tycoon",
        text = {
            "{C:red}Bonus Blinds{} cards appear",
            "{C:attention}#1#X{} more frequently",
            "in the shop"
        }
    },
    config = {rate = 3},
    atlas = 'vouchery',
    pos = {x = 1, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {3}}
    end,
    requires = {'v_bb_bonus1'},
    redeem = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            if G.GAME.selected_back.name == "Ante Deck" then
                G.GAME.bonus_rate = 10*self.config.rate
            else
                G.GAME.bonus_rate = 2*self.config.rate
            end
        return true end }))
    end
}

SMODS.Joker {
    key = 'change',
    name = "Loose Change",
    loc_txt = {
        name = "Loose Change",
        text = {
            "{C:attention}Bonus Blinds{} give",
            "reward money."
        }
    },
    rarity = 2,
    atlas = 'jokery',
    pos = {x = 0, y = 0},
    cost = 7,
    blueprint_compat = false
}

SMODS.Booster {
   key = 'blind_normal_1',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
        name = "Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.3,
    name = "Blind Pack",
    pos = {x = 0, y = 0},
    config = {extra = 3, choose = 1, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end
}

SMODS.Booster {
   key = 'blind_normal_2',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
        name = "Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.3,
    name = "Blind Pack",
    pos = {x = 1, y = 0},
    config = {extra = 3, choose = 1, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end
}

SMODS.Booster {
   key = 'blind_jumbo_1',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
    name = "Jumbo Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.3,
    cost = 6,
    name = "Jumbo Blind Pack",
    pos = {x = 0, y = 1},
    config = {extra = 5, choose = 1, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end
}

SMODS.Booster {
   key = 'blind_mega_1',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
        name = "Mega Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.07,
    cost = 8,
    name = "Mega Blind Pack",
    pos = {x = 1, y = 1},
    config = {extra = 5, choose = 2, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.RED, G.C.BLACK, 0.9))
        ease_background_colour{new_colour = G.C.FILTER, special_colour = G.C.BLACK, contrast = 2}
    end,
}

SMODS.Back {
    key = 'ante',
    loc_txt = {
        name = "Ante Deck",
        text = {
            "{C:red}Bonus Blinds{} show up",
            "more often.",
            "Required score scales far",
            "faster for each {C:attention}Ante"
        }
    },
    name = "Ante Deck",
    pos = { x = 0, y = 0 },
    atlas = 'decks',
    apply = function(self)
        G.GAME.bonus_rate = 10
    end
}

----- Blinds ---

SMODS.Atlas({ key = "blinds", atlas_table = "ANIMATION_ATLAS", path = "blinds.png", px = 34, py = 34, frames = 21 })

SMODS.Blind {
    loc_txt = {
        name = 'The Watch',
        text = { 'The Eye and Psychic', 'simultaneously' }
    },
    key = 'watch',
    name = 'The Watch',
    config = {},
    boss = {min = 1, max = 10, bonus = true},
    boss_colour = HEX("008A19"),
    atlas = "blinds",
    pos = { x = 0, y = 0},
    vars = {},
    dollars = 5,
    mult = 2,
    set_blind = function(self)
        G.GAME.blind.hands = {
            ["Flush Five"] = false,
            ["Flush House"] = false,
            ["Five of a Kind"] = false,
            ["Straight Flush"] = false,
            ["Four of a Kind"] = false,
            ["Full House"] = false,
            ["Flush"] = false,
            ["Straight"] = false,
            ["Three of a Kind"] = false,
            ["Two Pair"] = false,
            ["Pair"] = false,
            ["High Card"] = false,
        }
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if #cards < 5 then
            G.GAME.blind.triggered = true
            return true
        end
        if G.GAME.blind.hands[handname] then
            G.GAME.blind.triggered = true
            return true
        end
        if not check then G.GAME.blind.hands[handname] = true end
    end,
    get_loc_debuff_text = function(self)
        return "Must play 5 Cards and no repeat hand types this round"
    end,
    in_pool = function(self)
        return false
    end
}

----------------

function bonus_new_round(theBlind, bonusData)
    G.RESET_JIGGLES = nil
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
            G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
            G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            G.GAME.current_round.hands_played = 0
            G.GAME.current_round.discards_used = 0
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}

            for k, v in pairs(G.GAME.hands) do 
                v.played_this_round = 0
            end

            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end

            local chaos = find_joker('Chaos the Clown')
            G.GAME.current_round.free_rerolls = #chaos
            calculate_reroll_cost(true)

            G.GAME.round_bonus.next_hands = 0
            G.GAME.round_bonus.discards = 0

            local blhash = 'S'
            -- if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
            --     G.GAME.round_resets.blind_states.Small = 'Current'
            --     G.GAME.current_boss_streak = 0
            --     blhash = 'S'
            -- elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
            --     G.GAME.round_resets.blind_states.Big = 'Current'
            --     G.GAME.current_boss_streak = 0
            --     blhash = 'B'
            -- else
            --     G.GAME.round_resets.blind_states.Boss = 'Current'
            --     blhash = 'L'
            -- end
            G.GAME.subhash = (G.GAME.round_resets.ante)..(blhash)

            -- local customBlind = {name = 'The Ox', defeated = false, order = 4, dollars = 5, mult = 2,  vars = {localize('ph_most_played')}, debuff = {}, pos = {x=0, y=2}, boss = {min = 6, max = 10, bonus = true}, boss_colour = HEX('b95b08')}
            G.GAME.blind:set_blind(G.P_BLINDS[theBlind])
            G.GAME.blind.config.bonus = bonusData
            G.GAME.last_blind.boss = nil
            G.GAME.blind_on_deck = 'Bonus'
            if not next(SMODS.find_card("j_bb_change")) then
                G.GAME.blind.dollars = 0
                G.GAME.current_round.dollars_to_be_earned = ''
            end
            G.HUD_blind.alignment.offset.y = -10
            G.HUD_blind:recalculate(false)
            bonus_start_effect(bonusData)
            
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({setting_blind = true, blind = G.GAME.round_resets.blind})
            end
            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.DRAW_TO_HAND
                    G.deck:shuffle('nr'..G.GAME.round_resets.ante)
                    G.deck:hard_set_T()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
            end
        }))
end

function bonus_selection(theBlind, bonusData)
    stop_use()
    if G.blind_select then 
        G.GAME.facing_blind = true
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object:pop_out(5)
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object:pop_out(5) 

        G.E_MANAGER:add_event(Event({
        trigger = 'before', delay = 0.2,
        func = function()
            G.blind_prompt_box.alignment.offset.y = -10
            G.blind_select.alignment.offset.y = 40
            G.blind_select.alignment.offset.x = 0
            return true
        end}))
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            ease_round(1)
            inc_career_stat('c_rounds', 1)
            if _DEMO then
            G.SETTINGS.DEMO_ROUNDS = (G.SETTINGS.DEMO_ROUNDS or 0) + 1
            inc_steam_stat('demo_rounds')
            G:save_settings()
            end
            -- G.GAME.round_resets.blind = e.config.ref_table
            -- G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = 'Current'
            G.blind_select:remove()
            G.blind_prompt_box:remove()
            G.blind_select = nil
            delay(0.2)
            return true
        end}))
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            bonus_new_round(theBlind, bonusData)
            return true
        end
        }))
    end
end

function bonus_start_effect(bonusData)
    if bonusData.blind_size_mod then
        G.GAME.blind.chips = G.GAME.blind.chips + bonusData.blind_size_mod
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if bonusData.blind_mult then
        G.GAME.blind.mult = G.GAME.blind.mult * bonusData.blind_mult
        G.GAME.blind.chips = G.GAME.blind.chips * bonusData.blind_mult
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if bonusData.hands then
        ease_hands_played(bonusData.hands-G.GAME.current_round.hands_left + (G.GAME.blind.hands_sub or 0))
    end
    if bonusData.double_hands then
        ease_hands_played(G.GAME.current_round.hands_left)
    end
    if bonusData.discards then
        ease_discard(bonusData.discards-G.GAME.current_round.discards_left + (G.GAME.blind.discards_sub or 0))
    end
    if bonusData.ante_mod then
        ease_ante(bonusData.ante_mod)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + bonusData.ante_mod
        G.GAME.blind.chips = G.GAME.blind.chips * get_blind_amount(G.GAME.round_resets.blind_ante)
        G.GAME.blind.chips = G.GAME.blind.chips / get_blind_amount(G.GAME.round_resets.blind_ante - bonusData.ante_mod)
        G.GAME.blind.chips = math.floor(G.GAME.blind.chips)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if bonusData.hand_size then
        G.hand:change_size(bonusData.hand_size)
    end
    if bonusData.eternal_round then
        local eternals = {}
        for i, j in ipairs(G.jokers.cards) do
            if j.config.center.eternal_compat and not j.ability.eternal then
                table.insert(eternals, j)
            end
        end
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
            for i, j in ipairs(eternals) do
                G.E_MANAGER:add_event(Event({ func = function() j:flip();play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);return true end }))
                delay(0.15)
            end
            delay(0.23)
            for i, j in ipairs(eternals) do
                j.ability.blind_eternal = true
                G.E_MANAGER:add_event(Event({ func = function() j.ability.eternal = true;play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);j:flip();return true end }))
                delay(0.15)
            end
            return true
        end}))
    end
    if bonusData.pin_jokers then
        local pins = {}
        local sorts = {}
        for i, j in ipairs(G.jokers.cards) do
            local index = j.sort_id
            local i0 = 1
            while (i0 <= #sorts) and (index < sorts[i0]) do
                i0 = i0 + 1
            end
            table.insert(pins, j)
            table.insert(sorts, i0, j.sort_id)
        end
        for i, j in ipairs(G.jokers.cards) do
            j.sort_id = sorts[i]
        end
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
            for i, j in ipairs(pins) do
                G.E_MANAGER:add_event(Event({ func = function() j:flip();play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);return true end }))
                delay(0.15)
            end
            for i, j in ipairs(pins) do
                G.E_MANAGER:add_event(Event({ func = function() j.pinned = true;return true end }))
            end
            delay(0.23)
            for i, j in ipairs(pins) do
                G.E_MANAGER:add_event(Event({ func = function() play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);j:flip();return true end }))
                delay(0.15)
            end
            return true
        end}))
    end
    if bonusData.flip_jokers then
        for i, j in ipairs(G.jokers.cards) do
            j:flip()
        end
        G.E_MANAGER:add_event(Event({ func = function() play_sound('card1',  0.85);return true end }))
    end
    if bonusData.lotto then
        local pool = {}
        local chosen = {}
        for i, j in pairs(G.playing_cards) do
            table.insert(pool, j)
        end
        for i = 1, bonusData.lotto.cards do
            local card, key = pseudorandom_element(G.playing_cards, pseudoseed('lottery'))
            table.remove(pool, key)
            table.insert(chosen, card)
        end
        for i, j in pairs(chosen) do
            j.ability.perma_bonus_mult = j.ability.perma_bonus_mult or 0
            j.ability.perma_bonus_mult = j.ability.perma_bonus_mult + bonusData.lotto.amount
        end
    end
    if bonusData.emp_jkr then
        if #G.jokers.cards + bonusData.emp_jkr > G.jokers.config.card_limit then
            local deletes = {}
            local pool = {}
            for i = 1, #G.jokers.cards do
                if (not G.jokers.cards[i].abilty or not G.jokers.cards[i].abilty.eternal) and (not G.jokers.cards[i].edition or not G.jokers.cards[i].edition.negative) then
                    table.insert(pool, G.jokers.cards[i])
                end
            end
            if #pool > #G.jokers.cards + bonusData.emp_jkr - G.jokers.config.card_limit then
                for i = 1, #G.jokers.cards + bonusData.emp_jkr - G.jokers.config.card_limit do
                    local card, index = pseudorandom_element(pool, pseudoseed('empty'))
                    table.insert(deletes, card)
                    table.remove(pool, index)
                end
            else
                deletes = pool
            end
            local first = nil
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
                for k, v in pairs(deletes) do
                    v:start_dissolve(nil, first)
                    first = true
                end
            return true end }))
        end
    end
end

function bonus_reward(bonusData)
    if bonusData.tags then
        for i, j in ipairs(bonusData.tags) do
            add_tag(Tag(j))
        end
    end
    if bonusData.flip_jokers then
        for i, j in ipairs(G.jokers.cards) do
            j:flip()
        end
        G.E_MANAGER:add_event(Event({ func = function() play_sound('card1',  0.85);return true end }))
    end
    if bonusData.rand_reward then
        local val = pseudorandom(pseudoseed('reward'))
        if val < 1/6 then
            local val2 = 0.9 + (0.1 * pseudorandom(pseudoseed('rarity')))
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = create_card('Joker', G.jokers, nil, val2, nil, nil, nil, 'rew')
                            card:add_to_deck()
                            G.jokers:emplace(card)
                            card:set_edition({negative = true})
                            return true
                        end
                    }))                     
                    return true
            end)}))
        elseif val < 1/3 then
            add_tag(Tag('tag_double'))
            add_tag(Tag('tag_double'))
        elseif val < 1/2 then
            local val2 = 10 + math.floor(60 * pseudorandom(pseudoseed('money')))
            ease_dollars(val2)
        elseif val < 2/3 then
            local polys = {}
            local pool = {}
            for i = 1, #G.playing_cards do
                if not G.playing_cards[i].edition then
                    table.insert(pool, G.playing_cards[i])
                end
            end
            if #pool > 4 then
                for i = 1, 4 do
                    local card, index = pseudorandom_element(pool, pseudoseed('poly'))
                    table.insert(polys, card)
                    table.remove(pool, index)
                end
            else
                polys = pool
            end
            for i, j in ipairs(polys) do
                j:set_edition({polychrome = true}, nil, true)
            end
            play_sound('polychrome1', 1.2, 0.7)
        elseif val < 5/6 then
            add_tag(Tag('tag_ethereal'))
            add_tag(Tag('tag_ironic'))
        else
            add_tag(Tag('tag_voucher'))
            add_tag(Tag('tag_voucher'))
        end
    end
    if bonusData.free_rerolls then
        G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + bonusData.free_rerolls
        calculate_reroll_cost(true)
    end
end

function bonus_end_of_round(bonusData)
    if bonusData.burn_hand then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                local i = #G.hand.cards
                while (i >= 1) do
                    local card = G.hand.cards[i]
                    if card.ability.name == 'Glass Card' then 
                        card:shatter()
                    else
                        card:start_dissolve(nil, i == #G.hand.cards)
                    end
                    i = i - 1
                end
                return true 
            end 
        }))
        delay(0.5)
    end
    if bonusData.hand_size then
        G.hand:change_size(-1 * bonusData.hand_size)
    end
    if bonusData.eternal_round then
        local eternals = {}
        for i, j in ipairs(G.jokers.cards) do
            if j.ability.blind_eternal then
                table.insert(eternals, j)
            end
        end
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
            for i, j in ipairs(eternals) do
                G.E_MANAGER:add_event(Event({ func = function() j:flip();play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);return true end }))
                delay(0.15)
            end
            delay(0.23)
            for i, j in ipairs(eternals) do
                j.ability.blind_eternal = nil
                G.E_MANAGER:add_event(Event({ func = function() j.ability.eternal = nil;play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);j:flip();return true end }))
                delay(0.15)
            end
            return true
        end}))
    end
end

function SMODS.current_mod.process_loc_text()
    G.localization.descriptions.Other["card_extra_mult"] = 
    {
        text = {
            "{C:red}+#1#{} extra mult"
        }
    }
    G.localization.misc.dictionary["k_blind_pack"] = "Blind Pack"
    G.localization.descriptions.Other["bl_watch"] = {}
    G.localization.descriptions.Other["bl_watch"].text = { 'Must play 5 cards.', 'No repeat hand', 'types this round.' }
    G.localization.descriptions.Other["bl_watch"].name = "The Watch"
    G.localization.descriptions.Other["bl_crimson"] = {}
    G.localization.descriptions.Other["bl_crimson"].name = localize{type ='name_text', key = 'bl_final_heart', set = 'Blind'}
    G.localization.descriptions.Other["bl_crimson"].text = localize{type = 'raw_descriptions', key = 'bl_final_heart', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_violet"] = {}
    G.localization.descriptions.Other["bl_violet"].name = localize{type ='name_text', key = 'bl_final_vessel', set = 'Blind'}
    G.localization.descriptions.Other["bl_violet"].text = localize{type = 'raw_descriptions', key = 'bl_final_vessel', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["t_irony"] = {}
    G.localization.descriptions.Other["t_irony"].name = "Ironic Tag"
    G.localization.descriptions.Other["t_irony"].text = { "Gives a free", "{C:red}Jumbo Blind Pack"}
    G.localization.descriptions.Other["p_jumbo_bl"] = {}
    G.localization.descriptions.Other["p_jumbo_bl"].name = "Jumbo Blind Pack"
    G.localization.descriptions.Other["p_jumbo_bl"].text = { "Choose {C:attention}1{} of up to", "{C:attention}5{C:red} Bonus Blinds{}"}
    G.localization.descriptions.Other["bl_cerulean"] = {}
    G.localization.descriptions.Other["bl_cerulean"].name = localize{type ='name_text', key = 'bl_final_bell', set = 'Blind'}
    G.localization.descriptions.Other["bl_cerulean"].text = localize{type = 'raw_descriptions', key = 'bl_final_bell', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_snatch"] = {}
    G.localization.descriptions.Other["bl_snatch"].name = localize{type ='name_text', key = 'bl_hook', set = 'Blind'}
    G.localization.descriptions.Other["bl_snatch"].text = localize{type = 'raw_descriptions', key = 'bl_hook', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_rocky"] = {}
    G.localization.descriptions.Other["bl_rocky"].name = localize{type ='name_text', key = 'bl_flint', set = 'Blind'}
    G.localization.descriptions.Other["bl_rocky"].text = localize{type = 'raw_descriptions', key = 'bl_flint', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_snake"] = {}
    G.localization.descriptions.Other["bl_snake"].name = localize{type ='name_text', key = 'bl_serpent', set = 'Blind'}
    G.localization.descriptions.Other["bl_snake"].text = localize{type = 'raw_descriptions', key = 'bl_serpent', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["blind_ox"] = {}
    G.localization.descriptions.Other["blind_ox"].name = localize{type ='name_text', key = 'bl_ox', set = 'Blind'}
    G.localization.descriptions.Other["blind_ox"].text = localize{type = 'raw_descriptions', key = 'bl_ox', set = 'Blind', vars = {localize('ph_most_played')}}
    -- G.localization.descriptions.Other["ed_negative_consumable"] = {}
    -- G.localization.descriptions.Other["ed_negative_consumable"].name = localize{type ='name_text', key = 'e_negative_consumable', set = 'Edition'}
    -- G.localization.descriptions.Other["ed_negative_consumable"].text = localize{type = 'raw_descriptions', key = 'e_negative_consumable', set = 'Edition', vars = {1}}
end

local old_amount = get_blind_amount
function get_blind_amount(ante)
    local old = old_amount(ante)
    local k = (old/old)*1.5
    if G.GAME.selected_back.name == "Ante Deck" then
        if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then 
            local amounts = {
              300,  1000, 4000,  15000,  30000,  60000,   100000,  200000
            }
            if ante < 1 then return (old/old)*100 end
            if ante <= 8 then return (old/old)*amounts[ante] end
            local a, b, c, d = (old/old)*amounts[8],(old/old)*1.6,ante-8, 1 + 0.2*(ante-8)
            local amount = (old/old)*math.floor(a*(b+(k*c)^d)^c)
            amount = amount - amount%(10^math.floor(math.log10(amount)-1))
            return amount
          elseif G.GAME.modifiers.scaling == 2 then 
            local amounts = {
              300,  1500, 6000,  18000,  50000,  90000,   180000,  350000
            }
            if ante < 1 then return (old/old)*100 end
            if ante <= 8 then return (old/old)*amounts[ante] end
            local a, b, c, d = (old/old)*amounts[8],(old/old)*1.6,ante-8, 1 + 0.2*(ante-8)
            local amount = (old/old)*math.floor(a*(b+(k*c)^d)^c)
            amount = amount - amount%(10^math.floor(math.log10(amount)-1))
            return amount
          else
            local amounts = {
              300,  2000, 8000,  35000,  100000,  350000,   500000,  1000000
            }
            if ante < 1 then return (old/old)*100 end
            if ante <= 8 then return (old/old)*amounts[ante] end
            local a, b, c, d = (old/old)*amounts[8],(old/old)*1.6,ante-8, 1 + 0.2*(ante-8)
            local amount = (old/old)*math.floor(a*(b+(k*c)^d)^c)
            amount = amount - amount%(10^math.floor(math.log10(amount)-1))
            return amount
        end
    end
    return old
end

----------------------------------------------
------------MOD CODE END----------------------