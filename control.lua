local function should_ignore_enemies()
    return settings.startup["legendary-normal-ignore-enemies"].value
end

local enemy_types = {
    "unit",
    "unit-spawner",
    "turret",
    "segmented-unit",
    "spider-unit",
}

local function is_enemy_entity(entity)
    if not entity or not entity.valid then return false end

    local entity_type = entity.prototype.type
    local entity_name = entity.name

    if string.find(entity_name, "demolisher") then
        return false
    end

    for _, etype in pairs(enemy_types) do
        if entity_type == etype then
            if entity_type == "turret" then
                return string.find(entity_name, "worm") ~= nil
            end
            return true
        end
    end
    return false
end

local function migrate_basic_enemies()
    if not should_ignore_enemies() then return end
    if not prototypes.quality["basic"] then return end

    local total_migrated = 0

    for _, surface in pairs(game.surfaces) do
        local migrated = 0

        for _, entity in pairs(surface.find_entities_filtered({ force = "enemy" })) do
            if entity.valid and entity.quality and entity.quality.name == "basic" then
                if is_enemy_entity(entity) then
                    local name = entity.name
                    local position = entity.position
                    local force = entity.force
                    local direction = entity.direction

                    entity.destroy()
                    surface.create_entity({
                        name = name,
                        position = position,
                        force = force,
                        direction = direction,
                        quality = prototypes.quality["normal"],
                    })
                    migrated = migrated + 1
                end
            end
        end

        if migrated > 0 then
            game.print("Legendary Normal: Migrated " .. migrated .. " enemies to normal quality on " .. surface.name)
            total_migrated = total_migrated + migrated
        end
    end

    if total_migrated > 0 then
        game.print("Legendary Normal: Migration complete. Total: " .. total_migrated .. " enemies updated.")
    end
end

script.on_configuration_changed(function()
    migrate_basic_enemies()
end)
