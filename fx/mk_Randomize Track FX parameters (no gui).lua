--[[
ReaScript Name: Randomize Track FX parameters (no gui)
Description: Randomizes all parameters in focused track fx (except for protected ones). This is a reworking of MPL's Randomize Track parameters script, except this version doesn't have a gui and just randomizes everything.
Instructions: Focus an fx on a track and run the script
Author: Mads Kjeldgaard
Author URl: http://madskjeldgaard.dk
Repository: GitHub > madskjeldgaard > ReaScripts
Repository URl: https://github.com/madskjeldgaard/ReaScripts
Licence: GPL v3
Version: 1.0
REAPER: 5.973
]]

protected_table = {
    "upsmpl",
    "upsampl",
    "render",
    "gain", 
    "vol", 
    "on" ,
    "off",
    "wet",
    "dry",
    "oversamp",
    "alias",
    "input",
    "power",
    "solo",
    "mute",
    "feed",

    "attack",
    --"decay",
    "sustain",
    "release",

    "bypass",
    "dest",
    "mix",
    "out",
    "make",
    "auto",
    "level",
    "peak",
    "limit",
    "velocity",
    "active",
    "master"
}

function GetProtectedState(track, fx, param)
    local _, buf = reaper.TrackFX_GetParamName( track, fx, param, '' )
    local t = {}
    for word in buf:gmatch('[%a]+') do t [#t+1] = word end
    if #t == 0 then return false end
    for i = 1, #t do
        local par_name = t[i]
        protect = false
        for j = 1, #protected_table do
            if par_name:lower():find(protected_table[j])~=nil then return true end
        end
    end 
    return false
end

------------------------------------------------------------

function ENGINE_GetParams()
    local params = {}

    local retval, tracknumberOut, _, fxnumberOut = reaper.GetFocusedFX()
    local track = reaper.GetTrack(0, tracknumberOut-1)
    if track == nil then return end
    params.fxnumberOut = fxnumberOut
    params.guid = reaper.TrackFX_GetFXGUID( track, params.fxnumberOut )
    params.tracknumberOut = tracknumberOut
    _, params.fx_name =  reaper.TrackFX_GetFXName( track, params.fxnumberOut, '' )
    if retval ~= 1 or tracknumberOut <= 0 or params.fxnumberOut == nil then return end    
    local num_params = reaper.TrackFX_GetNumParams( track, params.fxnumberOut )
    if not num_params or num_params == 0 then return end    


    for i = 1, num_params do 
        local  is_prot = GetProtectedState(track, params.fxnumberOut, i-1 )
        params[i] =  {val = reaper.TrackFX_GetParamNormalized( track, params.fxnumberOut, i-1 ) ,
        is_act = false,
        is_protected = is_prot}
    end
    return params
end

------------------------------------------------------------

function ENGINE_SetParams()
    if def_params == nil then return end
    if rand_params == nil then return end
    -- if morph_val == nil then return end
    morph_val=1
    


    local retval, tracknumberOut, _, fxnumberOut = reaper.GetFocusedFX()
    track = reaper.GetTrack(0,tracknumberOut-1)
    _, fx_name = reaper.TrackFX_GetFXName( track, fxnumberOut, '' )
    guid = reaper.TrackFX_GetFXGUID( track, fxnumberOut )
    if def_params.tracknumberOut == tracknumberOut
        and def_params.guid == guid
        and def_params.fx_name == fx_name 
        and tracknumberOut > 0 
        and track ~= nil then

        max_params_count = 200
        for i = 1, math.min(#def_params, max_params_count) do
            if def_params[i].is_act then
                reaper.TrackFX_SetParamNormalized( track, fxnumberOut, i-1, 
                def_params[i].val + (rand_params[i] - def_params[i].val) * morph_val
                )
            end

        end

    end
end 

------------------------------------------------------------

function ENGINE_GenerateRandPatt(is_current)
    if def_params ~= nil then 
        local rand = {}
        local morph_params
        if is_current then morph_params = ENGINE_GetParams()  end
        for i = 1, #def_params do
            if is_current then
                rand[i] = math.random()
            end
        end
        return rand
    end
end

------------------------------------------------------------

function run()  
    time = math.abs(math.sin( -1 + (os.clock() % 2)))

    -- get params
    def_params = ENGINE_GetParams() 

    -- 2 pick
    pick_state = not pick_state

    if pick_state then
        _, _, _, paramnumber =reaper.GetLastTouchedFX()
        if def_params 
            and paramnumber +1 <= #def_params  
            and def_params[paramnumber+1] then  def_params[paramnumber+1].is_act = true
        end

        pick_state_cnt = 0
        if def_params then 
            for i = 1, #def_params do
                if def_params[i].is_act then pick_state_cnt = pick_state_cnt + 1 end
            end
        end
        update_gfx = true 
    end

    -- 2a get all
    if def_params  then  
        for i = 1, #def_params do def_params[i].is_act = true end
    end

    -- 2a get all except protected
    if def_params  then  
        for i = 1, #def_params do def_params[i].is_act = false end
        for i = 1, #def_params do 
            if not def_params[i].is_protected then def_params[i].is_act = true end 
        end
    end

    -- gen pattern
    rand_params = ENGINE_GenerateRandPatt(true) 

    -- morph
    ENGINE_SetParams()

end

run()
