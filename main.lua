-- Game created by Leo and Karl for the gamejam 2024.
---@diagnostic disable: lowercase-global, undefined-global

-- the player data
player = {
	x=-32, -- x position on the map in pixels
	y=-32, -- y position on the map in pixels
	animation=0 -- animation to play
}

-- the fixed position of the
-- player on the screen
ancor = {x=64,y=64}

-- the doors on the map
doors = {
	[0] = {x=8,y=3,d=1},
	[1] = {x=13,y=0,d=1},
	[2] = {x=13,y=6,d=1}
}

-- defined flags
flag_free = 0
flag_door = 1

-- returs the sprite based on the position of the player
-- please note that the position is in pixels
function get_sprite(x,y)
	local player_column = (x+ancor.x) / 8
	local player_row = (y+ancor.y) / 8

	return mget(
		player_column,
		player_row
	)
end

-- returns if a sprite at (x,y) position has the desired flag
function has_flag(x, y, f)
	return fget(get_sprite(x, y), f)
end

-- check if a plate is pressed
function check_plate(x, y)
	local sprite = get_sprite(x, y)
	if sprite >= 96 and sprite <= 99 then
		mset(
			(x+ancor.x) / 8,
			(y+ancor.y) / 8,
			100
		)
		unlock_door(sprite - 96)
	end
end

-- unlocks the doors on the map. 𝘵his starts at the 
function unlock_door(d)
	local door = doors[d]
	local door_x = door.x
	local door_y = door.y
	local sprite = mget(door.x, door.y)

	-- repeat until sprite has not the door flag
	while fget(sprite, flag_door) do
		mset(
			door_x,
			door_y,
			sprite - 48
		)
		door_y = door_y + door.d
		sprite = mget(
			door_x,
			door_y
		)
	end
end

-- save the square root of 2
sqrt_2 = sqrt(2)

-- function to handle key
-- input, moves the player
function handle_input()
	-- check buttons
	local dx = 0
	local dy = 0
	if btn(0) then dx=dx-1 end
	if btn(1) then dx=dx+1 end
	if btn(2) then dy=dy-1 end
	if btn(3) then dy=dy+1 end

	-- next position
	local dis = dx * dx + dy * dy
	local px = player.x + (dis and dx / sqrt_2 or dx)
	local py = player.y + (dis and dy / sqrt_2 or dy)

	-- check if it does not hit a wall
	if has_flag(px, py, flag_free) then
		handle_movement(px, py)
		handle_animation(dx, dy)
	end
end

function handle_movement(px, py)
	player.x = px
	player.y = py

	check_plate(px, py)
end

function handle_animation(dx, dy)
	local animation = 0
	if dx < 0 then animation=1
	elseif dx > 0 then animation=2
	elseif dy < 0 then animation=3
	end
	player.animation = animation
end

function _update()
	handle_input()
end

function _draw()
	cls(5)
	map(0, 0, -player.x,-player.y, 16, 16)
	spr(player.animation, ancor.x-4, ancor.y-8)
end