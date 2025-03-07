---@diagnostic disable: lowercase-global, undefined-global

-- the doors on the map
doors = {
	[0] = {x=10,y=5,w=1,h=3,activations=0},
	[1] = {x=19,y=4,w=1,h=5,activations=0},
	[2] = {x=23,y=4,w=1,h=5,activations=0},
	[3] = {x=32,y=4,w=1,h=5,activations=0},
	[4] = {x=41,y=15,w=1,h=5,activations=0},
	[5] = {x=45,y=15,w=1,h=5,activations=0},
	[6] = {x=41,y=23,w=1,h=5,activations=0},
	[7] = {x=45,y=23,w=1,h=5,activations=0},
	[13] = {x=76,y=12,w=5,h=1,activations=0},
	[14] = {x=70,y=13,w=5,h=1,activations=0},
	[15] = {x=65,y=19,w=1,h=5,activations=0},
}

door_switch = 32

-- unlocks the doors on the map. This starts at
-- the top corner of the defined (x,y) and replaces
-- all sprites with the sprite that is door_switch
-- lower than the original sprite.
function unlock_door(d)
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
