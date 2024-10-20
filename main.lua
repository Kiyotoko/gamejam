-- the player
player = {
	x=-32, -- x position on the map in pixels
	y=-32, -- y position on the map in pixels
	animation=0 -- animation to play
}

-- the fixed position of the
-- player on the screen
ancor = {x=64,y=64}

-- markers that are checked
checkmarks = 0

doors = {
	{
		{x=8,y=3},
		{x=8,y=4},
		{x=8,y=5}
	},
	{
		{x=13,y=0},
		{x=13,y=1},
		{x=13,y=2},
		{x=13,y=3},
		{x=13,y=4}
	},
	{
		{x=13,y=6},
		{x=13,y=7},
		{x=13,y=8},
		{x=13,y=9},
		{x=13,y=10},
		{x=13,y=11}
	}
}

-- returs the sprite based on the position of the player
-- please note that the position is in pixels
function get_sprite(x,y)
	player_column = (x+ancor.x) / 8
	player_row = (y+ancor.y) / 8

	return mget(
		player_column,
		player_row
	)
end

-- checks if a sprite at (x,y) position has the desired flag
function check_flag(x,y,f)
	return fget(get_sprite(x,y), f)
end

function check_plate(x,y)
	if check_flag(x, y, 1) then
		checkmarks = checkmarks + 1
		mset(
			(x+ancor.x) / 8,
			(y+ancor.y) / 8,
			get_sprite(x,y)+1
		)
		if checkmarks == 4 then
			unlock_doors()
		end
	end
end

-- unlocks all doors on the map
function unlock_doors()
	for _, door in ipairs(doors) do
		for _, pos in ipairs(door) do
		sprite = mget(
			pos.x,
			pos.y
		)
		mset(
			pos.x,
			pos.y,
			sprite - 48
		)
		end
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
	if (btn(0)) then dx=dx-1 end
	if (btn(1)) then dx=dx+1 end
	if (btn(2)) then dy=dy-1 end
	if (btn(3)) then dy=dy+1 end

	-- next position
	local dis = dx * dx + dy * dy
	local px = player.x + (dis and dx * sqrt_2 or dx)
	local py = player.y + (dis and dy * sqrt_2 or dy)
	
	-- check if it does not hit a wall
	if check_flag(px, py, 0)
	then
		handle_movement(px,py)
		handle_animation(dx,dy)
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
	player.animation = ani
end

function _update()
	handle_input()
end

function _draw()
	cls(5)
	map(0,0,-player.x,-player.y,16,16)
	print(checkmarks .. " / 4")
	spr(player.animation,ancor.x-4,ancor.y-8)
end