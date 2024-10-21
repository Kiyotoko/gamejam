---@diagnostic disable: lowercase-global, undefined-global

-- the player data
player = {
	x=-32, -- x position on the map in pixels
	y=-32, -- y position on the map in pixels
	animation=0, -- animation to play
	tick=0
}

-- the fixed position of the
-- player on the screen
ancor = {x=64,y=64}

-- the doors on the map
doors = {
	[0] = {x=8,y=3,w=1,h=3},
	[1] = {x=13,y=0,w=1,h=5},
	[2] = {x=13,y=6,w=1,h=6}
}

-- defined flags
flag_free = 0
flag_door = 1

-- plates
start_plate = 96
end_plate = 99
plate_activated = 100

function _update()
	handle_input()
end

function _draw()
	cls(5)
	map(0, 0, -player.x,-player.y, 16, 16)
	spr(player.animation, ancor.x-4, ancor.y-8)
end