---@diagnostic disable: lowercase-global, undefined-global

-- the player data
player = {
	x=-32, -- x position on the map in pixels
	y=-32, -- y position on the map in pixels
	animation = {
		x=0,
		y=0,
		tick=0
	},
	gold=0
}

-- the fixed position of the
-- player on the screen
ancor = {x=64,y=64}

-- defined flags
flag_free = 0
flag_door = 1

function _update()
	handle_input()
end

function _draw()
	cls(5)
	map(0, 0, -player.x,-player.y, 16, 16)

	if player.animation.tick > 5 then
		player.animation.y = (player.animation.y + 1) % 3
		player.animation.tick = 0
	else
		player.animation.tick = player.animation.tick + 1
	end

	if player.animation.x > 4 then
		sspr((player.animation.x  - 3) * 16, player.animation.y * 16, 16, 16, ancor.x-4, ancor.y-8, 16, 16, true, false)
	else
		sspr(player.animation.x * 16, player.animation.y * 16, 16, 16, ancor.x-4, ancor.y-8, 16, 16, false, false)
	end
end