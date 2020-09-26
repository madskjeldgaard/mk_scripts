#!/usr/bin/zsh 

declare -a NUMS=("1" "3" "5" "8" "10" "50" "100")

for iterations in ${NUMS[@]}
do

	mutate="true"
	rotate="false"
	randomizerate="false"

	TITLE="mk_$iterations x rand params applied to item as new take mutate:$mutate rotate:$rotate randomizerate:$randomizerate"

echo "--[[
ReaScript Name: $TITLE
Description: $TITLE
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
iterations=$iterations
mutate=$mutate
rotate=$rotate
randomize_rate=$randomizerate

-- 
package.path=reaper.GetResourcePath()..'/Scripts/mk_scripts/fx/lib/lib_recursivelyfocusedrandfx.lua'
recursive_ran_fx = require('recursivelyfocusedrandfx')

recursive_ran_fx.main(iterations, mutate, rotate, randomize_rate)
" > "$TITLE.lua"
done
