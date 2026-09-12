local quality_level = settings.startup["legendary-normal-quality-level"].value
local ignore_enemies = settings.startup["legendary-normal-ignore-enemies"].value
local ignore_asteroids = settings.startup["legendary-normal-ignore-asteroids"].value

if ignore_enemies then
    local basic_quality = table.deepcopy(data.raw.quality["normal"])
    basic_quality.name = "basic"
    basic_quality.level = 0
    basic_quality.color = { r = 0, g = 0, b = 0 }
    basic_quality.localised_name = { "quality-name.basic" }
    data:extend({ basic_quality })
end

data.raw.quality["normal"].level = quality_level

local default_multiplier = 1 + 0.3 * quality_level
local range_multiplier = math.min(1 + 0.1 * quality_level, 3)

local function counteract_health_scaling(entity)
    if entity.max_health then
        entity.max_health = entity.max_health / default_multiplier
    end
end

local function counteract_range_scaling(entity)
    if entity.attack_parameters and entity.attack_parameters.range then
        entity.attack_parameters.range = entity.attack_parameters.range / range_multiplier
    end
end

local function counteract_damage_scaling(entity)
    if entity.attack_parameters then
        entity.attack_parameters.damage_modifier = (entity.attack_parameters.damage_modifier or 1) / default_multiplier
    end
end

local function counteract_trigger_damage(trigger)
    if not trigger then return end
    for _, item in pairs(trigger) do
        if item.action_delivery and item.action_delivery.target_effects then
            for _, effect in pairs(item.action_delivery.target_effects) do
                if effect.type == "damage" and effect.damage then
                    effect.damage.amount = effect.damage.amount / default_multiplier
                end
            end
        end
    end
end

local function counteract_enemy_scaling(entity)
    counteract_health_scaling(entity)
    counteract_range_scaling(entity)
    counteract_damage_scaling(entity)
end

local quality_to_drain_100 = {
    [0] = 100,
    [1] = 83,
    [2] = 66,
    [3] = 50,
    [4] = 16,
}

local quality_to_drain_50 = {
    [0] = 50,
    [1] = 41,
    [2] = 33,
    [3] = 25,
    [4] = 8,
}

local function get_drain(lookup, level)
    return lookup[math.min(level, 4)] or lookup[0]
end

local drain_100 = get_drain(quality_to_drain_100, quality_level)
local drain_50 = get_drain(quality_to_drain_50, quality_level)

local drain_overrides = {
    ["burner-mining-drill"]   = drain_100,
    ["electric-mining-drill"] = drain_100,
    ["big-mining-drill"]      = drain_50,
    ["pumpjack"]              = drain_100,
}

for name, drain in pairs(drain_overrides) do
    if data.raw["mining-drill"] and data.raw["mining-drill"][name] then
        data.raw["mining-drill"][name].resource_drain_rate_percent = drain
    end
end

if ignore_enemies and quality_level > 0 then
    for _, entity in pairs(data.raw["unit"] or {}) do
        counteract_enemy_scaling(entity)
    end

    for _, entity in pairs(data.raw["spider-unit"] or {}) do
        counteract_enemy_scaling(entity)
    end

    for _, entity in pairs(data.raw["unit-spawner"] or {}) do
        counteract_health_scaling(entity)
    end

    for name, entity in pairs(data.raw["turret"] or {}) do
        if string.find(name, "worm") then
            counteract_enemy_scaling(entity)
        end
    end

    for name, entity in pairs(data.raw["segmented-unit"] or {}) do
        if string.find(name, "demolisher") then
            counteract_enemy_scaling(entity)
        end
    end

    for name, entity in pairs(data.raw["segment"] or {}) do
        if string.find(name, "demolisher") then
            counteract_health_scaling(entity)
        end
    end

    for name, stream in pairs(data.raw["stream"] or {}) do
        if string.find(name, "acid") then
            counteract_trigger_damage(stream.initial_action)
            counteract_trigger_damage(stream.action)
        end
    end

    for name, fire in pairs(data.raw["fire"] or {}) do
        if string.find(name, "acid") then
            if fire.damage_per_tick then
                fire.damage_per_tick.amount = fire.damage_per_tick.amount / default_multiplier
            end
        end
    end

    for name, sticker in pairs(data.raw["sticker"] or {}) do
        if string.find(name, "acid") then
            if sticker.damage_per_tick then
                sticker.damage_per_tick.amount = sticker.damage_per_tick.amount / default_multiplier
            end
        end
    end
end

if ignore_asteroids and quality_level > 0 then
    for _, entity in pairs(data.raw["asteroid"] or {}) do
        counteract_health_scaling(entity)
    end
end
