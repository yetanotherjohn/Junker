local ilvlThreshold = 260

function Junker(debug)
    local debug = debug or nil;
    
    -- WoW throttles sales but the script keeps running
    -- stop script to avoid useless processing
    local quantitySold = 0 

	for currentBag = 0, 6 do

        if quantitySold == 12 then
            break
        end    
    
		for currentSlot = 1, C_Container.GetContainerNumSlots(currentBag) do

            if quantitySold == 12 then
                break
            end

            local containerInfo  = C_Container.GetContainerItemInfo(currentBag,currentSlot)

            if containerInfo ~= nil and containerInfo.hyperlink ~= nil then
                _, _, _, _, _, classID, subclassID = GetItemInfoInstant(containerInfo.hyperlink)
                effectiveILvl, _, _ = GetDetailedItemLevelInfo(containerInfo.hyperlink)  -- avoid selling timewalking loot with effectiveILvl

                    if
                    (containerInfo.quality == 0 and containerInfo.hasNoValue == false) or -- is grey and is sellable OR
                    (containerInfo.quality ~= nil and containerInfo.quality < 5 and containerInfo.hasNoValue == false) and -- is not an oddball item, is less than legendary, is sellable AND
                    (containerInfo.isBound == true ) and         -- is not transferrable AND
                    ((classID == 4 and subclassID ~= 5) or       -- is armor but not cosmetic, OR
                    (classID == 2 and subclassID ~= 20)) and     -- is weapon but not fishing poles, AND
                    (effectiveILvl <= ilvlThreshold and effectiveILvl > 1) -- is below item level threshold but greater than tabbard ilvl (1)
                    then
                        if debug == true then
                            print("Mock sale:" .. containerInfo.hyperlink .."," .. containerInfo.quality.."," .. classID.."," .. subclassID .. "," .. effectiveILvl)
                        else
                            C_Container.UseContainerItem(currentBag, currentSlot)
                            quantitySold = quantitySold + 1
                        end -- if debug
                    end -- sell cases
			end -- if currentItemLink
        end -- for currentSlot
    end -- for currentBag
end -- function


-- On Load
SLASH_JUNKER1 = '/junker';
SlashCmdList.JUNKER = function(msg,editbox)
	if msg == 'debug' then
        Junker(true);
	end
end


local BtnSellGrey = CreateFrame( "Button" , "SellGreyBtn" , MerchantFrame, "UIPanelButtonTemplate" )
BtnSellGrey:SetText("Purge")
BtnSellGrey:SetWidth(90)
BtnSellGrey:SetHeight(21)
BtnSellGrey:SetPoint("TopRight", -180, -30 )
BtnSellGrey:RegisterForClicks("AnyUp")
BtnSellGrey:SetScript("Onclick", Junker)