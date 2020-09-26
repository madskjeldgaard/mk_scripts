fraction_size=(-0.5)

------------------------
package.path=reaper.GetResourcePath().."/Scripts/mk_scripts/items/lib/lib_nudge-algos.lua"
nudge_algos = require("lib_nudge-algos")

nudge_algos.run(fraction_size)
