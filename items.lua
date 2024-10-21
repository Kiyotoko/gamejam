---@diagnostic disable: lowercase-global
activatables = {}

pickups = {}

pickup_range = 16

function place_gold(x, y)
    if player.gold > 0 then
        player.gold = player.gold - 1
        local gold = {x=x, y=y}
        table.insert(pickups, gold)
    end
end

function pickup_gold()
    local pos = 1
    for _, pickup in pairs(pickups) do 
        local dx = pickup.x - player.x
        local dy = pickup.y - player.y
        if (dx * dx + dy * dy < pickup_range) then
            player.gold = player.gold + 1
            table.remove(pickups, pos)
            break
        end
        pos = pos + 1
    end
end

function render_pickups()
    -- TODO: Render gold
end