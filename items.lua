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

gold_num=10
-- ITEM ANIM STARTING TILE NUMBERS (for use in place_*() function)
-- gold = 10
-- emerald = 11
-- ruby = 12
-- sapphire = 13
-- sigma (?) = 14
-- metal pipe = 15
-- copper coil = 42

-- places a gold nugget at the defined (x,y) position
function place_gold(x, y)
    if player.gold > 0 and player.drop_timeout == 0 then
        player.gold = player.gold - 1
        local gold = {sprite=gold_num + (1-(t_rel+1) % 2)*16 , x=x, y=y}
        add(pickups, gold)
        player.drop_timeout=10
    end
end

function pickup_gold()
    local pos = 1
    for _, pickup in pairs(pickups) do
        local dx = pickup.x * 8 - (player.x+ancor.x)
        local dy = pickup.y * 8 - (player.y+ancor.y)
        if (dx * dx + dy * dy < action_range) then
            fine("picked up gold!")
            player.gold = player.gold + 1
            deli(pickups, pos)
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
    pickup_gold()
end

-- test if an item is already at that position
function item_in_pos(x, y)
    for _, item in pairs(pickups) do
        if item.x == x and item.y == y then return true end
    end
    return false
end

function render_pickups()
    for _, item in pairs(pickups) do
        spr(item.sprite, item.x*8 - player.x, item.y*8 - player.y)
    end
end
