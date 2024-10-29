---@diagnostic disable: lowercase-global, undefined-global

---list of all items that can be picked up from
---the map. all pickups have a x and y position
---in tiles and the item sprite and name of this
---item.
pickups = {}

-- the max distance to activate a chest
action_range = 64

-- the max distance to pickup an item
item_range = 32

-- ids and names of all the different items
items = {
	gold = {id=152, name="gold"},
	emerald = {id=153, name="emerald"},
	ruby = {id=154, name="ruby"},
	sapphire = {id=155, name="sapphire"},
	sigma = {id=156, name="sigma?"},
	metal_pipe = {id=157, name="metal pipe"},
	copper_coil = {id=110, name="copper coil"},
	pyrite = {id=111, name="pyrite??"}
}

-- list of chests that can be still looted.
-- a chest is removed from the list after looting.
chests = {
	[1] = {x=2, y=3, drops=items.gold},
	[2] = {x=13, y=3, drops=items.emerald},
	[3] = {x=42, y=5, drops=items.ruby},
	[4] = {x=38, y=20, drops=items.gold},
	[5] = {x=58, y=17, drops=items.copper_coil},
	[6] = {x=56, y=6, drops=items.sigma},
	[7] = {x=77, y=15, drops=items.metal_pipe}
}

chest_flip = 32

---places the first item from the player inventory
---@param x number the x position in pixels
---@param y number the y position in pixels
function player_place_item(x, y)
	local num = count(player.items)
	if num > 0 then
		local item = player.items[num]
		place_item(to_map_column(x), to_map_row(y), item)
		deli(player.items, num)
	end
end

---places an item at the defined (x,y) position
---@param x integer the x position in tiles
---@param y integer the y position in tiles
---@param item table the id of the item
function place_item(x, y, item)
	local created = {data=item, x=x, y=y}
	add(pickups, created)
	check_plate(to_pixel(created.x) - ancor.x, to_pixel(created.y) - ancor.y)
end

---tries to pickup an item at the position of the player
function pickup_item()
	local pos = 1
	for _, pickup in pairs(pickups) do
		local dx = to_pixel(pickup.x) - to_map_x(player.x)
		local dy = to_pixel(pickup.y) - to_map_y(player.y)
		local dist = dx^2 + dy^2 -- may overflow
		if dist >= 0 and (dist < action_range) and (player.timeout == 0) then
			fine("picked up " .. pickup.data.name .."!")
			add(player.items, pickup.data)
			uncheck_plate(to_pixel(pickup.x) - ancor.x, to_pixel(pickup.y) - ancor.y)
			player.timeout = 10
			deli(pickups, pos)
			break
		end
		pos = pos + 1
	end
end

---activates a chest or pick ups an item
function activate_or_pickup()
	-- check for chests
	for _, chest in pairs(chests) do
		local dx = to_pixel(chest.x+1) - to_map_x(player.x)
		local dy = to_pixel(chest.y+1) - to_map_y(player.y)
		local dist = abs(dx^2 + dy^2) -- may overflow
		if dist < action_range then
			place_item(chest.x+0.5, chest.y+1.5, chest.drops)
			player.timeout = 10
			for x=0, 1 do
				for y=0, 1 do
					local px = chest.x + x
					local py = chest.y + y
					mset(px,py, mget(px, py) + chest_flip)
				end
			end
			del(chests, chest)
			return
		end
	end

	-- else pick up item
	pickup_item()
end

---calculates the score of the player. this is equivalent
---to the number of gold in the inventory.
---@return integer score the score of the player
function compute_score()
	local score = 0
	for _, item in pairs(player.items) do
		if item == items.gold then score = score +1 end
	end
	return score
end

---test if an item is already at that position
---@param x number the y position in pixels
---@param y number the x position in pixels 
---@return boolean in_position true if an item is at that position, false otherwise
function item_in_pos(x, y)
	for _, item in pairs(pickups) do
		local dx = to_pixel(item.x - to_map_column(x))
		local dy = to_pixel(item.y - to_map_row(y))
		local dist = dx^2 + dy^2 -- may overflow
		if dist >= 0 and dist < item_range then return true end
	end
	return false
end

function render_pickups()
	local min = {dist=2000, x=0, y=0}
	for _, item in pairs(pickups) do
		local dx = to_pixel(item.x) - to_map_x(player.x)
		local dy = to_pixel(item.y) - to_map_y(player.y)
		local dist = dx*dx + dy*dy
		if dist >= 0 and dist < min.dist then
			min = {dist=dist, x=item.x, y=item.y}
		end
	end

	-- var for animation of outline
	local dsize = 2*sin(animation_timer * 3.141592 / 180)

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
		spr((animation_timer < 10 and item.data.id or item.data.id + 16),
		to_pixel(item.x) - player.x,
		abs(animation_timer % 10 - 10) + to_pixel(item.y) - player.y)
	end
end

function render_inventory()
	local pos = 0
	for _, item in pairs(player.items) do
		spr(item.id, to_pixel(pos), 0)
		pos = pos + 1
	end
	color(loglevel.fine)
	print("score: " .. compute_score(), 50, 2)
end
