---@diagnostic disable: lowercase-global, undefined-global

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

-- unlocks the doors on the map. This starts at the 
function unlock_door(d)
	local door = doors[d]

	for x=0,door.w-1 do
		for y=0,door.h-1 do
			local sprite = mget(door.x + x, door.y + y)
			mset(
				door.x + x,
				door.y + y,
				sprite - 48
			)
		end
	end
end