-- game
-- by leo and karl
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

-- unlocks the doors on the map. This starts at the 
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

function _update()
	handle_input()
end

function _draw()
	cls(5)
	map(0, 0, -player.x,-player.y, 16, 16)
	spr(player.animation, ancor.x-4, ancor.y-8)
end