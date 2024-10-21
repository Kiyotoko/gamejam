---@diagnostic disable: lowercase-global, undefined-global

-- the player data
player = {
	x=-32, -- x position on the map in pixels
	y=-32, -- y position on the map in pixels
	offset = 4, -- value you have to add to plr.x and plr.y to get players center 
	animation = { -- the animation
		x=0,
		y=0,
		tick=0
	},
	vel = 0,
	vel_max = 1.5,
	accel=0.2,
	decel=0.5,
	prev = {
		dx = 0,
		dy = 0
	},
	lock=0, -- prevent dropping multiple items at once
	gold=0
}

palt(0, false) --make black visible
palt(7, true) --make white invisible

-- the fixed position of the
-- player on the screen
ancor = {x=64,y=64}

-- defined flags
flag_free = 0

function _init()
	player.gold = 3
	place_gold(3, 5)
	-- place_gold(4, 4)

	info("escape the dungeon")
end

function _update()
	handle_input()
end

function _draw()
	cls(5)
	map(0, 0, -player.x,-player.y, 16, 16)
	render_pickups()

	if player.animation.tick > 7 then
		player.animation.y = (player.animation.y + 1) % 4
		player.animation.tick = 0
	else
		player.animation.tick = player.animation.tick + 1
	end

	if player.animation.x > 4 then
		sspr((player.animation.x  - 3) * 16, player.animation.y * 16, 16, 16, ancor.x-4, ancor.y-8, 16, 16, true, false)
	else
		sspr(player.animation.x * 16, player.animation.y * 16, 16, 16, ancor.x-4, ancor.y-8, 16, 16, false, false)
	end

	show_message()
end
