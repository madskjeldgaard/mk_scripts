local ran_env_lib= {}

-- Insert random envelope points for selected items and track envelope (no interpolation)
num_items = reaper.CountSelectedMediaItems( 0 )

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
function insert_point(sel_env, position, interpolation)
    if sel_env then 

        -- Generate a value
        env_val = math.random(0, 1000) / 1000
        env_val = env_val * 2.0 -- Envelope values are 0.0-2.0

        -- Delete old point
        reaper.DeleteEnvelopePointRange( sel_env, i_pos, i_pos+1 )

        -- Insert new point
        reaper.InsertEnvelopePoint( sel_env, i_pos, env_val, interpolation * 10.0, 0, false, true)

        return 1
    else
        reaper.ReaScriptError( "No envelope selected" )

        return 0
    end
end

-- Go through all selected items and insert points
function items_loop(master_interpolation)
    if num_items then
        for i_num=0, num_items-1 do

            -- Item
            item = reaper.GetMediaItem( 0, i_num )

            if item then
                -- Position
                i_pos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) 

                -- Selected envelope
                sel_env = reaper.GetSelectedTrackEnvelope( 0 )

                insert_point(sel_env, i_pos, master_interpolation)
            end
        end
    else
        reaper.ReaScriptError( "No item(s) selected" )
    end
end

return ran_env_lib
