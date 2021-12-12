function Junker()
	TotalSale = 0
	for myBags = 0, 4 do
		for bagSlots = 1, GetContainerNumSlots(myBags) do
			CurrentItemLink = GetContainerItemLink(myBags, bagSlots)

				if CurrentItemLink then
					_, _, itemQuality, _, _, _, _, _, _, _, itemSellPrice, classID, subclassID, bindType = GetItemInfo(CurrentItemLink)
                    effectiveILvl, _, _ = GetDetailedItemLevelInfo(CurrentItemLink)  -- avoid selling timewalking loot with effectiveILvl
					_, itemCount = GetContainerItemInfo(myBags, bagSlots)

					-- debugging
                    -- print(GetItemInfo(CurrentItemLink))
                    -- print(GetDetailedItemLevelInfo(CurrentItemLink))

					-- not debugging
                    if (itemQuality == 0 and itemSellPrice ~= nil and itemSellPrice ~= 0) or -- is grey and has a vendor price, OR
                    
                       (itemQuality < 5 and itemSellPrice ~= nil and itemSellPrice ~= 0) and -- is less than legendary and has a vendor price, AND
                       (bindType == 1 ) and                         -- is BoP (bound because it's in bags), AND
                       ((classID == 4) or                           -- is armor, OR
                       (classID == 2 and subclassID ~= 20)) and     -- is weapon but not fishing poles and, AND
                       (effectiveILvl <= 80)                        -- is some arbitrarily low item level not even remotely useful as I see it
                    then
                        TotalSale = TotalSale + (itemSellPrice * itemCount)
						print(CurrentItemLink .. " x" ..itemCount .. ", " .. GetCoinTextureString(itemSellPrice * itemCount))
						UseContainerItem(myBags, bagSlots)
                    end
				end
		end
    end

	if TotalSale ~= 0 then
		print("Total Price for all items: " .. GetCoinTextureString(TotalSale))
	else
		print("No items were sold.")
	end
end

local BtnSellGrey = CreateFrame( "Button" , "SellGreyBtn" , MerchantFrame, "UIPanelButtonTemplate" )
BtnSellGrey:SetText("Purge")
BtnSellGrey:SetWidth(90)
BtnSellGrey:SetHeight(21)
BtnSellGrey:SetPoint("TopRight", -180, -30 )
BtnSellGrey:RegisterForClicks("AnyUp")
BtnSellGrey:SetScript("Onclick", Junker)