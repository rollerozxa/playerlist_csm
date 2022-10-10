
local huds_store = {}

local list_shown = false

local function playerlist()
	local sneak_held = minetest.localplayer:get_control().sneak

	if sneak_held and not list_shown then
		local huds = {minetest.localplayer:hud_add({
			hud_elem_type = "image",
			position = {x = 0.5, y = 0},
			offset = {x = 0, y = 20},
			text = "^[resize:8x8^[colorize:#111:255",
			alignment = {x = 0, y = 1},
			scale = {x = 40, y = #minetest.get_player_names() * 4},
			number = 0xFFFFFF,
		})}

		for i, name in ipairs(minetest.get_player_names()) do
			if i ~= 1 then -- for some reason the first name in the list is a duplicate of the current player
				table.insert(huds, minetest.localplayer:hud_add({
					hud_elem_type = "text",
					position = {x = 0.5, y = 0},
					offset = {x = 0, y = 23 + (i - 2) * 18},
					text = name,
					alignment = {x = 0, y = 1},
					scale = {x = 100, y = 100},
					number = color or 0xFFFFFF,
				}))
			end
		end
		huds_store = huds

		list_shown = true
	elseif not sneak_held and list_shown then
		for _, id in pairs(huds_store) do
			minetest.localplayer:hud_remove(id)
		end

		list_shown = false
	end
end

local init = 0
minetest.register_globalstep(function(dtime)
	if init > 0.1 then
		playerlist()
	else
		init = init + dtime
	end
end)
