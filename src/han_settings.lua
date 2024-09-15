local an, han = ...

han_db_t = han_db_t or {}
han_db_t.force_display = false
han_db_t.posx = 885
han_db_t.posy = 400
han_db_t.size = 50

han.load_settings = function()
	-- todo: implement
	han.settings = han_db_t or {}
end

han.save_settings = function()
	-- this should be invoked before logout etc... don't do this everytime a setting changes.
	--SaveVariables(han.settings)
end
