local quality_level = settings.startup["legendary-normal-quality-level"].value
local ignore_enemies = settings.startup["legendary-normal-ignore-enemies"].value
local ignore_asteroids = settings.startup["legendary-normal-ignore-asteroids"].value

if ignore_enemies then
    local basic_quality = table.deepcopy(data.raw.quality["normal"])
    basic_quality.name = "basic"
    basic_quality.level = 0
    basic_quality.next = nil
    basic_quality.next_probability = 0
    basic_quality.color = { r = 0, g = 0, b = 0 }
    basic_quality.localised_name = { "quality-name.basic" }
    data:extend({ basic_quality })
end

local normal_quality = data.raw.quality["normal"]
normal_quality.level = quality_level
normal_quality.beacon_power_usage_multiplier = math.max(1 / 6, 1 - quality_level / 6)
normal_quality.mining_drill_resource_drain_multiplier = math.max(1 / 6, 1 - quality_level / 6)
normal_quality.science_pack_drain_multiplier = 1 - quality_level / 100
normal_quality.locomotive_power_multiplier = 1 + 0.2 * quality_level
normal_quality.rolling_stock_max_speed_multiplier = 1 + 0.03 * quality_level

-- Vanilla wagon capacity grows by 25% per tier, then jumps from 1.75 to 2.5 at legendary.
if quality_level <= 3 then
    normal_quality.cargo_wagon_inventory_size_multiplier = 1 + 0.25 * quality_level
else
    normal_quality.cargo_wagon_inventory_size_multiplier = 1.75 + 0.375 * (quality_level - 3)
end

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

local scaled_triggers = {}

local function counteract_trigger_damage(trigger)
    if type(trigger) ~= "table" or scaled_triggers[trigger] then return end
    scaled_triggers[trigger] = true

    if trigger.type == "damage" and trigger.damage then
        trigger.damage.amount = trigger.damage.amount / default_multiplier
        return
    end

    for _, value in pairs(trigger) do
        if type(value) == "table" then
            counteract_trigger_damage(value)
        end
    end
end

local function counteract_enemy_scaling(entity)
    counteract_health_scaling(entity)
    counteract_range_scaling(entity)
    counteract_damage_scaling(entity)
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
end

if quality_level > 0 then
    for name, fire in pairs(data.raw["fire"] or {}) do
        if string.find(name, "acid") then
            if fire.damage_per_tick then
                fire.damage_per_tick.amount = fire.damage_per_tick.amount / default_multiplier
            end
        end
    end

    local sticker_modifiers = {
        "target_movement_modifier",
        "target_movement_modifier_from",
        "target_movement_modifier_to",
        "vehicle_speed_modifier",
        "vehicle_speed_modifier_from",
        "vehicle_speed_modifier_to",
        "vehicle_friction_modifier",
        "vehicle_friction_modifier_from",
        "vehicle_friction_modifier_to",
    }

    for name, sticker in pairs(data.raw["sticker"] or {}) do
        if string.find(name, "acid") then
            if sticker.damage_per_tick then
                sticker.damage_per_tick.amount = sticker.damage_per_tick.amount / default_multiplier
            end
            sticker.duration_in_ticks = math.max(1, math.floor(sticker.duration_in_ticks / default_multiplier + 0.5))

            -- Sticker quality scales the deviation from 1, rather than the modifier itself.
            for _, field in ipairs(sticker_modifiers) do
                if sticker[field] then
                    sticker[field] = 1 + (sticker[field] - 1) / default_multiplier
                end
            end
        end
    end
end

if ignore_asteroids and quality_level > 0 then
    for _, entity in pairs(data.raw["asteroid"] or {}) do
        counteract_health_scaling(entity)
    end
end
