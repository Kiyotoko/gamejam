---@diagnostic disable: lowercase-global

activaten_state = {}

-- plates
deactivated_plate_start = 192
deactivated_plate_end = 207
activated_plate_start = 208
activated_plate_end = 223

plate_switch = 16

---checks if a plate is pressed at the (x,y) position
---@param x number the position in pixels
---@param y number the position in pixels
function check_plate(x, y)
	local sprite = get_sprite(x, y)
	if sprite >= deactivated_plate_start
    and sprite <= deactivated_plate_end then
		set_sprite(x, y, sprite + plate_switch)

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

---check if a plate is deactivated at the (x,y) position
---@param x number the x position in pixels
---@param y number the y position in pixels
function uncheck_plate(x, y)
	local sprite = get_sprite(x, y)

	if sprite >= activated_plate_start
    and sprite <= activated_plate_end
	and not item_in_pos(x, y) then
		set_sprite(x, y, sprite - plate_switch)
		local action = sprite - activated_plate_start
        local state = activaten_state[action] - 1
        if state == 0 then
    		lock_door(action)
        end
        activaten_state[action] = state
	end
end
