-- toggle-geometry.lua
--
-- Author:  winny https://winny.tech/
-- License: Unlicense
--
-- Simple utility script to "fix" geometry on the fly, such that the
-- window manage does not need to force mpv to stay in a certain spot
-- or keep its window size.

local utils = require 'mp.utils'

function toggle_geometry()
   if mp.get_property('geometry') == '' then
      local g = mp.get_property('width') .. 'x' .. mp.get_property('height')
      mp.set_property('geometry', g)
      mp.osd_message('Set geometry to ' .. g)
   else
      mp.set_property('geometry', '')
      mp.osd_message('Clear geometry')
   end
end

mp.add_key_binding('Alt+a', mp.get_script_name(), toggle_geometry)
