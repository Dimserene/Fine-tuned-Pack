--- STEAMODDED HEADER
--- MOD_NAME: Shoot the Jimbo
--- MOD_ID: ShootJimbo
--- PREFIX: shjb
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: "there should be a mod that lets you shoot that helper joker fuck in the head" - silversnow__

SMODS.Atlas({ 
    key = "jimbo_shot", 
    atlas_table = "ASSET_ATLAS", 
    path = "jimbo_shot.png", 
    px = 71, 
    py = 95 
})

SMODS.Sound({
    key = "gunshot",
    path = "gunshot.ogg",
    pitch = 1,
    volume = 0.7
})

local initref = Card_Character.init
function Card_Character:init(args)
    initref(self, args)
    self.children.card.click = Card.gunshot_func
end

function Card:gunshot_func()
    if G.STATE == G.STATES.GAME_OVER then
        play_sound("shjb_gunshot", 1, 1)
        self.children.center.atlas = G.ASSET_ATLAS["shjb_jimbo_shot"]
        self.children.center:set_sprite_pos({x = 0, y = 0})
        self:juice_up()

        if not G.GAME.shot_jimbo then
            for k, v in pairs(G.I.CARD) do
                if getmetatable(v) == Card_Character then
                    v.children.particles = Particles(0, 0, 0,0, {
                        timer = 0.01,
                        scale = 0.3,
                        speed = 2,
                        lifespan = 4,
                        attach = v,
                        colours = {G.C.RED, G.C.RED, G.C.RED},
                        fill = true
                    })
                    v:remove_speech_bubble()
                    v.talking = false
                end
            end
        end

        G.GAME.shot_jimbo = true
    end
end