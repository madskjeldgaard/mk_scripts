package.path = reaper.GetResourcePath().."/Scripts/mk_scripts/fx/lib/lib_randomize_last_touched_track_fx.lua"
local randfx_lib = require("lib_randomize_last_touched_track_fx")

local this_module = {}

-- Reaper action command ids
local command_ids = {
	normalize_items = "40108",
	apply_fx_to_new_take = "40209",
	duplicate_active_Take = "40639",
	toggle_take_reverse = "41051",
	rand_rate ="",
	increase_rate_10c="40519",
	decrease_rate_10c="40800"
}

function randomize_fx()
	randfx_lib.main()
end

function rotate_item()
	local cmd=reaper.NamedCommandLookup(command_ids.toggle_take_reverse)
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function duplicate_take()
	local cmd=reaper.NamedCommandLookup(command_ids.duplicate_active_Take)
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function apply_fx()
    local cmd=reaper.NamedCommandLookup(command_ids.apply_fx_to_new_take)
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function reset_to_1st_take()
    local cmd=reaper.NamedCommandLookup("45000")
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function normalize_item()
    local cmd=reaper.NamedCommandLookup(command_ids.normalize_items)
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function random_rate()
    local uprate = reaper.NamedCommandLookup(command_ids.increase_rate_10c)
	local downrate = reaper.NamedCommandLookup(command_ids.decrease_rate_10c)

	local coin = math.random(0,1)

	if coin == 0 then
		reaper.Main_OnCommandEx(uprate, 0, 0)
	else
		reaper.Main_OnCommandEx(downrate, 0, 0)
	end
end

function this_module.main(numIterations, mutate, rotate, randomize_playback)
    for i=1,numIterations do

		randomize_fx()
        apply_fx()

		if randomize_playback then
			random_rate()
		end

		if rotate then
			rotate_item()
		end

		-- and apply as new take
        if not mutate then
            reset_to_1st_take()
        else
            normalize_item()
        end
    end
end

return this_module
