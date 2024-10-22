---@diagnostic disable: lowercase-global, undefined-global

activaten_state = {}

-- plates
deactivated_plate_start = 192
deactivated_plate_end = 207
activated_plate_start = 208
activated_plate_end = 223

plate_switch = 16

-- check if a plate is pressed
function check_plate(x, y)
	local sprite = get_sprite(x, y)
	if sprite >= deactivated_plate_start
    and sprite <= deactivated_plate_end then
		mset(
			(x+ancor.x) / 8,
			(y+ancor.y) / 8,
			sprite + plate_switch
		)

		local action = sprite - deactivated_plate_start
        if activaten_state[action] == nil then
            activaten_state[action] = 1
        else
            activaten_state[action] = activaten_state[action] + 1
        end
		if activaten_state[action] == 1 then
			-- only unlock door if it was previously locked
			-- if it was already unlocked, do nothing
			unlock_door(sprite - deactivated_plate_start)
		end
	end
end

function uncheck_plate(x, y)
	local sprite = get_sprite(x, y)
	local px = (x+ancor.x) / 8
	local py = (y+ancor.y) / 8

	if sprite >= activated_plate_start
    and sprite <= activated_plate_end
	and not item_in_pos(flr(px), flr(py)) then
		mset(
			px,
			py,
			sprite - plate_switch
		)
		local action = sprite - activated_plate_start
        local state = activaten_state[action] - 1
        if state == 0 then
    		lock_door(action)
        end
        activaten_state[action] = state
	end
end
