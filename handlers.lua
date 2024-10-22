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
	if btn(4) then
		activate_or_pickup()
	end
	if btn(5) then
		if not item_in_pos(player.x + player.offset, player.y + player.offset) then
			player_place_item(player.x + player.offset, player.y + player.offset)
		end
	end

	-- save dx,dy for next frame (for deceleration)
	if not (dx == 0 and dy == 0) then
		player.prev.dx, player.prev.dy = dx, dy
	end

	-- next position
	-- account for diagonals
	local px = player.x + player.prev.dx * player.vel * (1-(1-1/sqrt(2))*abs(dy))
	local py = player.y + player.prev.dy * player.vel * (1-(1-1/sqrt(2))*abs(dx))

	-- check if it does not hit a wall
	-- if it does, check other cases incase we can move along the wall
	if has_flag(px+player.offset, py+player.offset, flag_free) then handle_movement(px, py, dx, dy)
	elseif has_flag(player.x+player.offset, py+player.offset, flag_free) then handle_movement(player.x, py, dx, dy)
	elseif has_flag(px+player.offset, player.y+player.offset, flag_free) then handle_movement(px, player.y, dx, dy) end
	handle_animation(dx, dy)
end

function handle_movement(px, py, dx, dy)
	if get_sprite(player.x, player.y) ~= get_sprite(px, py) then
		uncheck_plate(player.x, player.y)
		check_plate(px, py)
	end

  -- change in velocity
  -- depends on dx, dy
	if dx == 0 and dy == 0 and player.vel > 0 then
		player.vel = player.vel - player.decel
	elseif (player.vel < player.vel_max) and not (dx == 0 and dy == 0) then
		player.vel = player.vel + player.accel
	elseif (player.vel < 0) then
		player.vel = 0
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
  if dx == 0 and dy == 0 then
    animation = player.animation.x -- keeps the current direction
    player.animation.y = 0 -- idle sprite of the current direction
    player.animation.tick = 0 -- halts the animation
  end
	player.animation.x = animation
end
