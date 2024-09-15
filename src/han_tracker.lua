local an, han = ...

function han_update(anshe_frame)
	local name = AuraUtil.FindAuraByName("Blessing of An'she", 'player')
	if name == nil then
		anshe_frame.texture:SetAlpha(0)
	else
		anshe_frame.texture:SetAlpha(1)
	end
end

function han_init()
	local anshe_frame = CreateFrame("Frame", nil, UIParent)
	anshe_frame:SetPoint("TOPLEFT", 885, -400)
	local box_size = 50
	anshe_frame:SetHeight(box_size)
	anshe_frame:SetWidth(box_size)
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

local f = CreateFrame("Frame")
f:RegisterEvent('ADDON_LOADED')
f:SetScript("OnEvent", function(self, event, arg1)
	if(event == 'ADDON_LOADED' and arg1 == an) then
		han_init()
	end
end)

