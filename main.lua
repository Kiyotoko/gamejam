---@diagnostic disable: lowercase-global, undefined-global

animation_timer = 0 -- time variable for non-player animations

-- the player data
player = {
	x=-32, -- x position on the map in pixels
	y=-16, -- y position on the map in pixels
	offset = 4, -- value you have to add to plr.x and plr.y to get players center 
	animation = { -- the animation
		x=0,
		y=0,
		tick=0
	},
	vel = 0,
	vel_max = 1.5,
	accel=0.1,
	decel=0.4,
	prev = {
		dx = 0,
		dy = 0
	},
	items={},
  timeout = 0,
}

palt(0, false) --make black visible
palt(6, true) --make light grey invisible color

-- the fixed position of the
-- player on the screen
ancor = {x=64,y=64}

-- defined flags
flag_free = 0

started = true

function _update()
	if started then
		for i=0, 5 do
			if btn(i) then
				started = false

				info("escape the dungeon")
				info("use ⬆️⬇️⬅️➡️ to move around")
				info("use 🅾️ to interact/pick up")
				info("use ❎ to drop items")
				info("hoard as much gold as possible")
				break
			end
		end
		return
	end
	handle_input()

	animation_timer = (animation_timer + 1) % 20

  	if player.timeout > 0 then player.timeout = player.timeout - 1 end

	-- counter for the info messages
	counter = counter + 1
	if counter > 80 then
		deli(messages, 1)
		counter = 0
	end
end

function _draw()
	cls(0)

	if started then
		sspr(10*8, 0, 6*8, 4*8, 0, 0, 6*8*2.5, 4*8*2.5)
		local msg = "press any button"
		color(loglevel.fine)
		print(msg, 64-#msg*2, 120)
		return
	end

	-- draw map
	local sx = max(0, flr(player.x/8))
	local sy = min(max(0, flr(player.y/8)), 13)
	map(sx, sy, sx*8-player.x,sy*8-player.y, 18, 18)
	-- map(0, 0, -player.x, -player.y, 127, 31)

	-- draw player
	if player.animation.tick > 7 then
		player.animation.y = (player.animation.y + 1) % 4
		player.animation.tick = 0
	else
		player.animation.tick = player.animation.tick + 1
	end
	-- shadow beneath player
	sspr(12*8, 7*8, 16, 8, ancor.x-4, ancor.y+4, 16, 8, false, false)
 	if player.animation.x > 4 then
		sspr((player.animation.x  - 3) * 16, player.animation.y * 16, 16, 16, ancor.x-4, ancor.y-8, 16, 16, true, false)
	else
		sspr(player.animation.x * 16, player.animation.y * 16, 16, 16, ancor.x-4, ancor.y-8, 16, 16, false, false)
	end

	-- draw pickups
	render_pickups()
	render_inventory()
	show_message()
end
