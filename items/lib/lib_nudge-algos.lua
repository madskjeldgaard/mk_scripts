local this_module = {}

infoitems = {}
num_items = reaper.CountSelectedMediaItems( 0 )

-- Go through all selected items 
function this_module.calculate_positions()
    if num_items ~= 0 then

        for i_num=0, num_items-1 do

            -- Item
            local item = reaper.GetSelectedMediaItem( 0, i_num )

            if item then
                -- Calculate position, length and edges and save in a sub table
                infoitems[i_num] = {}
                infoitems[i_num].item = item 
                infoitems[i_num].pos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) 
                infoitems[i_num].len = reaper.GetMediaItemInfo_Value( item, "D_LENGTH" ) 
                infoitems[i_num].left_edge = infoitems[i_num].pos                 
                infoitems[i_num].right_edge = infoitems[i_num].pos+infoitems[i_num].len 
            end
        end

    else
        reaper.ReaScriptError( "No item(s) selected" )
    end
end

function this_module.calculate_distances()
    -- For loop over infoitems table
    for i_num=0, #infoitems do

        -- calculate distance to next (unless last item)
        if i_num < #infoitems then
            -- put in table at item's position
            local current_item = infoitems[i_num]
            local next_item = infoitems[i_num+1]
            infoitems[i_num].distance = next_item.left_edge - current_item.right_edge
        end
    end
end

function this_module.nudge_items(fraction)
    for i=0, #infoitems-1 do
        local this_item = infoitems[i]
        local next_item = infoitems[i+1]

        -- New position of next item
        local next_item_new_pos = this_item.right_edge + ( this_item.distance * ( 1-fraction ) )

        -- Nudge next item left, ie closer to this item
        reaper.SetMediaItemPosition(next_item.item, next_item_new_pos, true)

        -- Recalculate distances and positions
        this_module.calculate_positions()
        this_module.calculate_distances()

        -- reaper.ShowConsoleMsg("Distance" .. i .. ": " .. this_item.distance .. "\n") 
    end
end

function this_module.run(fraction_size)
    this_module.calculate_positions()
    this_module.calculate_distances()
    this_module.nudge_items(fraction_size)
end

return this_module
