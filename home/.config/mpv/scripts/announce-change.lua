local function show_filename()
   mp.osd_message(mp.get_property_osd('filename'), 3)
end

mp.register_event('file-loaded', show_filename)
