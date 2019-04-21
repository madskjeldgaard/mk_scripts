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

function this_module.main(numIterations, mutate)
    for i=1,numIterations do
        -- Randomize fx params and apply as new take
        rand_params_apply_fx()

        if not mutate then
            reset_to_1st_take()
        else
            normalize_item()
        end
    end
end

return this_module
