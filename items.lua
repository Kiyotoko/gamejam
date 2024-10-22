---@diagnostic disable: lowercase-global, undefined-global

-- list of all items that can be picked up from
-- the map.
pickups = {}

-- the max distance to activate a chest
action_range = 64

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
pyrite = 43

-- map of the item names
item_names = {
    [gold] = "gold",
    [emerald] = "emerald",
    [ruby] = "ruby",
    [sapphire] = "sapphire",
    [sigma] = "sigma?",
    [metal_pipe] = "metal pipe",
    [copper_coil] = "copper coil",
    [pyrite] = "pyrite??"
}

-- list of chests that can be still looted.
-- a chest is removed from the list after looting.
chests = {
	[0] = {x=2, y=3, closed=true, drops=gold}
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
---@param item integer the id of the item
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
        if (dx * dx + dy * dy < action_range) and (player.timeout == 0) then
            local item = pickup.sprite - (t_rel % 2) * 16
            fine("picked up " .. item_names[item] .."!")
            add(player.items, item)
            deli(pickups, pos)
            uncheck_plate(to_pixel(pickup.x) - ancor.x, to_pixel(pickup.y) - ancor.y)
            player.timeout = 10
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

    -- else pick up item
    pickup_item()

    -- check for chests
    for _, chest in pairs(chests) do
		if chest.closed then
			local dx = to_pixel(chest.x+1) - to_map_x(player.x)
			local dy = to_pixel(chest.y+1) - to_map_y(player.y)
			if dx * dx + dy * dy < action_range then
				-- todo: activate chest
				place_item(chest.x+0.5, chest.y+1.5, chest.drops)
        chest.closed = false
        player.timeout = 10
				return
			end
		end
        pos = pos + 1
    end
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

function render_chests()
	for _, chest in pairs(chests) do
		sspr(80, (chest.closed and 32 or 48), 16, 16,
		to_pixel(chest.x) - player.x, to_pixel(chest.y) - player.y)
	end
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
