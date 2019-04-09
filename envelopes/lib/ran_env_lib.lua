local ran_env_lib= {}

-- Insert random envelope points for selected items and track envelope (no interpolation)
num_items = reaper.CountSelectedMediaItems( 0 )
--
-- num_items = reaper.CountTrackMediaItems( reaper.GetSelectedTrack( 0, 0) ) 

-- MAIN
function ran_env_lib.main(envelope_interpolation)
    -- Set random seed from operating system's time
    math.randomseed( os.time() )

    -- Loop through all selected items and perform the action
    -- Argument is interpolation amount
    items_loop(envelope_interpolation)

    -- For some reason this is needed to update the arrangement
    reaper.UpdateArrange()
end

-- Insert envelope point
function insert_point(in_env, position, interpolation)
    if in_env then 

        -- Generate a value
        local env_val = math.random(0, 1000) / 1000
        env_val = env_val * 2.0 -- Envelope values are 0.0-2.0

        -- Delete old point
        reaper.DeleteEnvelopePointRange( in_env, position, position+1 )

        -- Insert new point
        reaper.InsertEnvelopePoint( in_env, position, env_val, interpolation * 10.0, 0, false, false)

    else
        reaper.ReaScriptError( "No envelope selected" )
    end
end

-- Go through all selected items and insert points
function items_loop(master_interpolation)
    if num_items then

        for i_num=0, num_items-1 do

            -- Item
            local item = reaper.GetSelectedMediaItem( 0, i_num )

            if item then
                -- Position
                local i_pos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) 

                -- Selected envelope
                local sel_env = reaper.GetSelectedTrackEnvelope( 0 )

                -- Set new point
                insert_point(sel_env, i_pos, master_interpolation)

                -- Sort the new points in time 
                reaper.Envelope_SortPoints( sel_env )
            end
        end

    else
        reaper.ReaScriptError( "No item(s) selected" )
    end
end

return ran_env_lib
