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
        if activaten_state[sprite] == nil then
            activaten_state[sprite] = 1
        else
            activaten_state[sprite] = activaten_state[sprite] + 1
        end
		unlock_door(sprite - deactivated_plate_start)
	end
end

function uncheck_plate(x, y)
	local sprite = get_sprite(x, y)
	if sprite >= activated_plate_start
    and sprite <= activated_plate_end then
		mset(
			(x+ancor.x) / 8,
			(y+ancor.y) / 8,
			sprite - plate_switch
		)
        local state = activaten_state[sprite - plate_switch] - 1
        if state == 0 then
    		lock_door(sprite - plate_switch - deactivated_plate_start)
        end
        activaten_state[sprite - plate_switch] = state
	end
end
