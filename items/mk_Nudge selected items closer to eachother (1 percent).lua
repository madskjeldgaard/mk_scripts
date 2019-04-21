fraction_size=0.01

------------------------
package.path=reaper.GetResourcePath().."/Scripts/Mads Scripts/items/lib/lib_nudge-algos.lua"
nudge_algos = require("lib_nudge-algos")

nudge_algos.run(fraction_size)
