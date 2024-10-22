---@diagnostic disable: lowercase-global, undefined-global

-- list of chests that can be still looted.
-- a chest is removed from the list after looting.
activatables = {}

-- list of all items that can be picked up from
-- the map.
pickups = {}

-- the max distance to pickup an item or to activate
-- a chest.
action_range = 24

item_range = 32

-- ITEM ANIM STARTING TILE NUMBERS (for use in place_*() function)
gold = 10
emerald = 11
ruby = 12
sapphire = 13

item_names = {
    [gold] = "gold",
    [emerald] = "emerald",
    [ruby] = "ruby",
    [sapphire] = "sapphire"
}

-- sigma (?) = 14
-- metal pipe = 15
-- copper coil = 42

function player_place_item(x, y)
    local item = player.items[1]
    if item ~= nil then
        place_item(flr(x), flr(y), item)
        deli(player.items, 1)
    end
end

-- places an item at the defined (x,y) position
-- position in tiles
function place_item(x, y, item)
    local created = {sprite=item + (1-(t_rel+1) % 2)*16, x=x, y=y}
    add(pickups, created)
    check_plate(created.x, created.y)
end

function pickup_item()
    local pos = 1
    for _, pickup in pairs(pickups) do
        local dx = pickup.x * 8 - (player.x+ancor.x)
        local dy = pickup.y * 8 - (player.y+ancor.y)
        if (dx * dx + dy * dy < action_range) then
            local item = pickup.sprite - (t_rel % 2) * 16
            fine("picked up " .. item_names[item] .."!")
            add(player.items, item)
            deli(pickups, pos)
            uncheck_plate(pickup.x, pickup.y)
            break
        end
        pos = pos + 1
    end
end

-- simple 2 step animations for items 
-- also adds periodical vertical movement to them
function animate_pickups()
  for _, pickup in ipairs(pickups) do
    if t % 10 == 0 then
      pickup.sprite = pickup.sprite + (t_rel % 2 - (t_rel+1) % 2)*16
      pickup.y = pickup.y + (t_rel/2 % 2 - (t_rel/2+1) % 2)/8
    end
  end
end

function activate_or_pickup()
    local pos = 1

    -- check for chests
    for _, actions in pairs(activatables) do
        local dx = actions.x * 8 - (player.x+ancor.x)
        local dy = actions.y * 8 - (player.y+ancor.y)
        if dx * dx + dy * dy < action_range then
            -- todo: Activate chest
            deli(activatables, pos)
            return
        end
        pos = pos + 1
    end

    -- else pickup item
    pickup_item()
end

-- test if an item is already at that position
-- position in pixels
function item_in_pos(x, y)
    for _, item in pairs(pickups) do
        local dx = item.x * 8 - x
        local dy = item.y * 8 - y
        if dx*dx+dy*dy < item_range then return true end
    end
    return false
end

function render_pickups()
    for _, item in pairs(pickups) do
        spr(item.sprite, item.x*8 - player.x, item.y*8 - player.y)
    end
end

function render_inventory()
    local pos = 0
    for _, item in pairs(player.items) do
        spr(item, pos * 8, 0)
        pos = pos + 1
    end
end