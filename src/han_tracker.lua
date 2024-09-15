local an, han = ...

local function get_dimensions()
	local w = GetScreenWidth() * UIParent:GetEffectiveScale()
	local h = GetScreenHeight() * UIParent:GetEffectiveScale()
	return w, h
end

local function make_slider(parent, title, x, y, value_changed_func, min, max, initial_val, tooltip)
	local sl = CreateFrame("Slider", title, parent, "OptionsSliderTemplate")
	sl:SetMinMaxValues(min, max)
	sl:SetValue(min + max / 2)
	sl:SetPoint("TOPLEFT", x, y)
	sl:SetScript("OnValueChanged", function(self, value)
		value_changed_func(self, value)
	end)
	local label = sl:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("BOTTOM", sl, "TOP", 0, 5)
	label:SetText(title)
end

local function make_checkbox(parent, title, x, y, on_click_func, initial_val, tooltip)
	local cb = CreateFrame("CheckButton", title, parent, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", x, y)
	cb:SetScript("OnClick", function(self)
		local value = self:GetChecked()
		self:GetCheckedTexture():SetDesaturated(not value)
		on_click_func(self, value)
	end)
	if(tooltip ~= nil) then
		cb:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(tooltip, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		cb:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	cb.Text:SetText(title)
	cb:SetChecked(initial_val)
end

local function impl_han_options_menu(panel)
	local dx, dy = get_dimensions()
	local slider_x = make_slider(panel, "X Position", 16, -84, function(ui, value)
		han.settings.posx = value
	end, 0, dx, han.settings.posx, "X Coordinate of the swing timer UI element")

	local slider_y = make_slider(panel, "Y Position", 16, -128, function(ui, value)
		han.settings.posy = value
	end, 0, dy, han.settings.posy, "Y Coordinate of the swing timer UI element")

	local slider_size = make_slider(panel, "Icon Size", 16, -172, function(ui, value)
		han.settings.size = value
	end, 1, 100, han.settings.size, "Size of the An'she Icon (when you have the buff)")

	local force_display_checkbox = make_checkbox(panel, "Force Display Icon", 16, -216, function(ui, value)
		han.settings.force_display = value
	end, han.settings.force_display, "Display the An'she Icon even if you don't currently have the debuff (Testing purposes)")
end

function han_update(anshe_frame)
	local name = AuraUtil.FindAuraByName("Blessing of An'she", 'player')
	if not han.settings.force_display and name == nil then
		anshe_frame.texture:SetAlpha(0)
	else
		anshe_frame.texture:SetAlpha(1)
	end
	anshe_frame:SetPoint("TOPLEFT", han.settings.posx, -han.settings.posy)
	anshe_frame:SetHeight(han.settings.size)
	anshe_frame:SetWidth(han.settings.size)
end

function han_init()
	-- an'she icon display when the buff is detected.
	do
		local anshe_frame = CreateFrame("Frame", nil, UIParent)
		anshe_frame.texture = anshe_frame:CreateTexture()
		anshe_frame.texture:SetAllPoints(anshe_frame)
		anshe_frame.texture:SetTexture("Interface/Icons/INV_Ability_HolyFire_Orb")

		local time_elapsed = 0
		anshe_frame:HookScript("OnUpdate", function(self, elapsed)
			time_elapsed = time_elapsed + elapsed
			while (time_elapsed > 0.05) do
				-- 20 times per second: update
				time_elapsed = time_elapsed - 0.05
				han_update(anshe_frame)
			end
		end)
	end

	-- and then an options frame for the addons interface.
	do
		local panel = CreateFrame("Frame", "HarrandAnshe_Options", InterfaceOptionsFramePanelContainer)
		panel.name = "Harrand An'She Tracker"
		panel:SetScript("OnShow", impl_han_options_menu)
		local category, layout = _G.Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		_G.Settings.RegisterAddOnCategory(category)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent('ADDON_LOADED')
f:SetScript("OnEvent", function(self, event, arg1)
	if(event == 'ADDON_LOADED' and arg1 == an) then
		han.load_settings()
		han_init()
	end
end)

