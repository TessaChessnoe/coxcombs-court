--- STEAMODDED HEADER
--- MOD_NAME: CCourt
--- MOD_ID: CCourt
--- MOD_AUTHOR: [Tessa Chessnoe]
--- MOD_DESCRIPTION: My first mod. Mostly adds vanilla like jokers to buff less viable builds. 
--- PREFIX: ccourt

-- Altas is used to access joker sprite sheet
SMODS.Atlas{
    key = 'Jokers',
    path = 'Jokers.png',
    -- Width of each card
    px = 71,
    -- Height of each card
    py = 95
}

-- Declare joker name, text, and unlock cond
SMODS.Joker{
    key = 'j_commune',
    rarity = 3,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    loc_txt = {
        name = 'The Commune',
        text = {
            "{X:mult,C:white} X#1# {} Mult if played",
            "hand contains",
            "a {C:attention}#2#"
        }
    },
    atlas = 'Jokers',
    pos = {x = 0, y = 0},
    config = { extra = {Xmult = 4, poker_hand = "Full House"}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult, center.ability.extra.poker_hand}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            -- BUG: Does not proc when scoring flush house
            if context.scoring_name == card.ability.extra.poker_hand then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult, 
                -- Show Xmult next to cards when joker procs
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end
end
}

SMODS.Joker{
    key = 'j_house_rep',
    rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    loc_txt = {
        name = 'House Rep.',
        text = {
            "{C:attention} First played {C:attention}card{}",
            "permanently gains",
            "{C:chips}+#1#{} Chips when scored", 
            "hand contains",
            "a {C:attention}#2#"
        }
    },
    -- atlas = 'Jokers',
    -- pos = {x = 71, y = 0},
    config = { extra = {chip_mod = 20, poker_hand = "Full House"}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.chip_mod, center.ability.extra.poker_hand}}
    end,
    calculate = function(self, card, context)
        -- If a full house is played, perm. upgrade first scored card
        local handPlayed = context.cardarea == G.play
        local isFullHouse = context.scoring_name == card.ability.extra.poker_hand
        local isFirstCard = context.other_card == context.scoring_hand[1]
        if handPlayed and isFullHouse and isFirstCard then
            -- Increment card value by chip mod
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + self.ability.extra.chip_mod
            return {
                card = card,
                -- Show upgrade me
                message = "Upgrade!",
                colour = G.C.CHIPS
            }
        end
    end
}