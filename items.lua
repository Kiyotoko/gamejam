---@diagnostic disable: lowercase-global, undefined-global

-- list of chests that can be still looted.
-- a chest is removed from the list after looting.
chests = {
	[0] = {x=0, y=0, drops=gold}
}

-- list of all items that can be picked up from
-- the map.
pickups = {}

-- the max distance to activate a chest
action_range = 24

-- the max distance to pickup an item
item_range = 32

-- ids of the different items
gold = 10
emerald = 11
ruby = 12
sapphire = 13
sigma = 14
metal_pipe = 15
copper_coil = 42

-- map of the item names
item_names = {
    [gold] = "gold",
    [emerald] = "emerald",
    [ruby] = "ruby",
    [sapphire] = "sapphire",
    [sigma] = "sigma?",
    [metal_pipe] = "metal pipe",
    [copper_coil] = "copper coil"
}

---places the first item from the player inventory
---@param x number the x position in pixels
---@param y number the y position in pixels
function player_place_item(x, y)
    local item = player.items[1]
    if item ~= nil then
        place_item(to_map_column(x), to_map_row(y), item)
        deli(player.items, 1)
    end
end

---places an item at the defined (x,y) position
---@param x integer the x position in tiles
---@param y integer the y position in tiles
function place_item(x, y, item)
    local created = {sprite=item + (1-(t_rel+1) % 2)*16, x=x, y=y}
    add(pickups, created)
    check_plate(to_pixel(created.x) - ancor.x, to_pixel(created.y) - ancor.y)
end

function pickup_item()
    local pos = 1
    for _, pickup in pairs(pickups) do
        local dx = to_pixel(pickup.x) - to_map_x(player.x)
        local dy = to_pixel(pickup.y) - to_map_y(player.y)
        if (dx * dx + dy * dy < action_range) then
            local item = pickup.sprite - (t_rel % 2) * 16
            fine("picked up " .. item_names[item] .."!")
            add(player.items, item)
            deli(pickups, pos)
            uncheck_plate(to_pixel(pickup.x) - ancor.x, to_pixel(pickup.y) - ancor.y)
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
---@param x number the y position in pixels
---@param y number the x position in pixels 
---@return boolean
function item_in_pos(x, y)
    for _, item in pairs(pickups) do
        local dx = to_pixel(item.x - to_map_column(x))
        local dy = to_pixel(item.y - to_map_row(y))
        if dx*dx+dy*dy < item_range then return true end
    end
    return false
end

function render_pickups()
    --TODO: quicker sort ?  
    local min = {dist = 2000, x=0,y=0}
    for _, item in pairs(pickups) do
		local dx = to_pixel(item.x) - to_map_x(player.x)
		local dy = to_pixel(item.y) - to_map_y(player.y)
		local dist = sqrt(dx * dx + dy * dy)
		if dist < min.dist then
			min = {dist = dist, x=item.x, y=item.y}
		end
    end

    -- var for animation of outline
    local dsize = 2*sin(t*3.141592/180)

    -- draw red outline if player is close 
    if min.dist < 50 then
      	ovalfill(
			min.x*8 - ceil(player.x) - dsize,
			min.y*8 - ceil(player.y) - dsize,
            min.x*8 - ceil(player.x) + dsize + 8,
			min.y*8 - ceil(player.y) + dsize + 8,
			8
        )
    end

    for _, item in pairs(pickups) do
        spr(item.sprite, to_pixel(item.x) - player.x, to_pixel(item.y) - player.y)
    end
end

function render_inventory()
    local pos = 0
    for _, item in pairs(player.items) do
        spr(item, to_pixel(pos), 0)
        pos = pos + 1
    end
end
