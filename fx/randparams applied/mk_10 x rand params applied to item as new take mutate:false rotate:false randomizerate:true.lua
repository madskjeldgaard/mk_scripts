--[[
ReaScript Name: mk_10 x rand params applied to item as new take mutate:false rotate:false randomizerate:true
Description: mk_10 x rand params applied to item as new take mutate:false rotate:false randomizerate:true
Instructions: Select item(s) and execute. Last touched track fx will be applied.
Author: Mads Kjeldgaard
Author URl: http://madskjeldgaard.dk
Repository: GitHub > madskjeldgaard > mk_scripts
Repository URl: https://github.com/madskjeldgaard/mk_scripts
Licence: GPL v3
Version: 1.2
REAPER: 5.973
]]

-- USER AREA
iterations=10
mutate=false
rotate=false
randomize_rate=true

-- 
package.path=reaper.GetResourcePath()..'/Scripts/mk_scripts/fx/lib/lib_recursivelyfocusedrandfx.lua'
recursive_ran_fx = require('recursivelyfocusedrandfx')

recursive_ran_fx.main(iterations, mutate, rotate, randomize_rate)

