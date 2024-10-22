---@diagnostic disable: lowercase-global, undefined-global

loglevel = {
	warn = 136,
	fine = 139,
	info = 140
}

message = nil
level = loglevel.fine

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

function show_message()
	if message ~= nil then
		color(level)
		print(message, 4, 4)
	end
end

function warn(msg)
	level = loglevel.warn
	message = msg
end

function info(msg)
	level = loglevel.info
	message = msg
end

function fine(msg)
	level = loglevel.fine
	message = msg
end