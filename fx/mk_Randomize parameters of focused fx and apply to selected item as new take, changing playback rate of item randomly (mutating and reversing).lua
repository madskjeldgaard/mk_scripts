local this_module = {}

function rand_params_apply_fx()
    cmd=reaper.NamedCommandLookup("_be4374199ee54994b250bd223f7621a9")
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function reset_to_1st_take()
    cmd=reaper.NamedCommandLookup("45000")
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function normalize_item()
    cmd=reaper.NamedCommandLookup("40108")
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function randomize_take_rate()
    cmd=reaper.NamedCommandLookup("_RSfc68df5576c2034116a0b68f88a2a270bb225d5b")
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function reverse_take()
    cmd=reaper.NamedCommandLookup("41051")
    reaper.Main_OnCommandEx(cmd, 0, 0)
end

function this_module.main(numIterations, mutate)
    for i=1,numIterations do
        -- Reverse
        reverse_take()

        -- Rand playback rate (normal distribution)
        randomize_take_rate()

        -- Randomize fx params and apply as new take
        rand_params_apply_fx()

        if not mutate then
            reset_to_1st_take()
        else
            normalize_item()

        end
    end
end

this_module.main(5, true)

return this_module
