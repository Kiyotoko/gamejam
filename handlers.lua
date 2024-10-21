---@diagnostic disable: lowercase-global, undefined-global

-- function to handle key
-- input, moves the player
function handle_input()
	-- check buttons
	local dx = 0
	local dy = 0
	if btn(0) then dx=dx-1 end
	if btn(1) then dx=dx+1 end
	if btn(2) then dy=dy-1 end
	if btn(3) then dy=dy+1 end

	-- next position
	local px = player.x + dx
	local py = player.y + dy

	-- check if it does not hit a wall
	if has_flag(px, py, flag_free) then
		handle_movement(px, py)
		handle_animation(dx, dy)
	end
end

function handle_movement(px, py)
	if get_sprite(player.x, player.y) ~= get_sprite(px, py) then
		uncheck_plate(player.x, player.y)
		check_plate(px, py)
	end

	player.x = px
	player.y = py

end

function handle_animation(dx, dy)
	local animation = 0
	if dx < 0 then animation = 2
	elseif dx > 0 then animation = 5
	end

	if dx ~= 0 then
		if dy < 0 then animation = animation + 1
		elseif dy > 0 then animation = animation + 2
		end
	else
		if dy < 0 then animation = 1
		elseif dy > 0 then animation = 0
		end
	end
	player.animation.x = animation
end