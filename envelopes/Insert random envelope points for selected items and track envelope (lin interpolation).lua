--[[
ReaScript Name: Insert random envelope points for selected items and track envelope (random interpolation)
Description: Insert random envelope points for selected items and track envelope (random interpolation)
Instructions: Select items in a track and select an envelope in the track, run the script
Category: Here some infos.
Author: Mads Kjeldgaard
Author URl: http://madskjeldgaard.dk
Repository: GitHub > madskjeldgaard > ReaScripts
Repository URl: https://github.com/madskjeldgaard/ReaScripts
File URl: https://github.com/madskjeldgaard/ReaScripts/scriptName.eel
Licence: GPL v3
Forum Thread: 
Forum Thread URl: http://forum.cockos.com/***.html
Version: 1.0
REAPER: 5.973
]]

-- USER AREA
envelope_interpolation=0.7

-- Import the core package
package.path=reaper.GetResourcePath().."/Scripts/Mads Scripts/envelopes/lib/ran_env_lib.lua"
ran = require("ran_env_lib")

ran.main(envelope_interpolation)
