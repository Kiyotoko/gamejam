---@diagnostic disable: lowercase-global, undefined-global

-- the doors on the map
doors = {
	[0] = {x=10,y=5,w=1,h=3},
	[1] = {x=21,y=3,w=1,h=7},
	[2] = {x=25,y=3,w=1,h=7}
}

door_switch = 32

-- unlocks the doors on the map. This starts at
-- the top corner of the defined (x,y) and replaces
-- all sprites with the sprite that is door_switch
-- lower than the original sprite.
function unlock_door(d)
	fine("a door opened!")
	local door = doors[d]

	for x=0,door.w-1 do
		for y=0,door.h-1 do
			local sprite = mget(door.x + x, door.y + y)
			mset(
				door.x + x,
				door.y + y,
				sprite - door_switch
			)
		end
	end
end

function lock_door(d)
    local door = doors[d]

    for x=0,door.w-1 do
		for y=0,door.h-1 do
			local sprite = mget(door.x + x, door.y + y)
			mset(
				door.x + x,
				door.y + y,
				sprite + door_switch
			)
		end
	end
end
