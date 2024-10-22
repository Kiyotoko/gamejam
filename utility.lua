---@diagnostic disable: lowercase-global, undefined-global

loglevel = {
	warn = 136,
	fine = 139,
	info = 140
}

message = nil
level = loglevel.fine

---calculates a sprite position in pixles
---@param value integer the sprite position
---@return number pixel the positin in pixels
function to_pixel(value)
	return value * 8
end

---transforms to the real map pixel position
---@param x number the x position in pixels
---@return number
function to_map_x(x)
	return (x + ancor.x)
end

---transforms to the real map pixel position
---@param y number the y position in pixels
---@return number
function to_map_y(y)
	return (y + ancor.y)
end

---transforms a pixel coordinate to the tile map column position
---@param x number
---@return integer
function to_map_column(x)
	return flr(to_map_x(x) / 8)
end

---transforms a pixel coordinate to the tile map row position
---@param y number
---@return integer
function to_map_row(y)
	return flr(to_map_y(y) / 8)
end

---returs the sprite based on the position of the player
---@param x number the x position in pixels
---@param y number the y position in pixles
---@return integer sprite the sprite
function get_sprite(x, y)
	return mget(
		to_map_column(x),
		to_map_row(y)
	)
end

---sets the sprite on the tile map
---@param x integer the x position
---@param y integer the y position
---@param sprite integer the sprite
function set_sprite(x, y, sprite)
	mset(
		to_map_column(x),
		to_map_row(y),
		sprite
	)
end

---returns if a sprite at (x,y) position has the desired flag
function has_flag(x, y, f)
	return fget(get_sprite(x, y), f)
end

function show_message()
	if message ~= nil then
		color(0)
		print(" - " .. message .. " - ", 17, 121)
		color(level)
		print(" - " .. message .. " - ", 16, 120)
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
