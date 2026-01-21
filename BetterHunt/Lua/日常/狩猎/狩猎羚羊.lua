local hunt_api = require("Common/hunt")

local function get_goat_hunt_options()
    local options = {
        i18n_text("卖给当地猎户(1200银两)"),
    }

    local item1Prob = math.random(1, 7)
    if item1Prob <= 2 and player_menpai_has_role("朱三娘") then
        item1 = "三娘的肉包"
        item1Count = 3
        table.insert(options, item_tip_link(item1, i18n_text("带回去给[朱三娘]制成肉包"), "#000000"))
    elseif item1Prob >= 7 then
        item1 = "赠送烤串"
        item1Count = 1
        table.insert(options, item_tip_link(item1, i18n_text("拖回去烤成串"), "#000000"))
    else
        item1 = "肉排"
        item1Count = 2
        table.insert(options, item_tip_link(item1, i18n_text("拖回去烤肉排"), "#000000"))
    end

    local item2Prob = math.random(1, 7)
    if item2Prob <= 2 then
        item2 = "地羊丸"
        item2Count = 2
    elseif item2Prob >= 7 then
        item2 = "赠送地羊丸"
        item2Count = 1
    else
        item2 = "地羊丹"
        item2Count = 2
    end
    if has_flag("已解锁药店") then
        table.insert(options, item_tip_link(item2, i18n_text("带回去制成[" .. string.gsub(item2, "赠送", "精制") .. "]"), "#000000"))
    end

    return options, item1, item1Count, item2, item2Count
end

local function onHuntSuccess()
    local options, item1, item1Count, item2, item2Count = get_goat_hunt_options()

    local idx = show_avg_select("", "这些猎获的羚羊你打算如何处理?", options)
    switch(idx)
    {
        ["1"] = function()
            add_player_money(1200)
        end,
        ["2"] = function()
            add_player_item(item1, item1Count)
        end,
        ["3"] = function()
            add_player_item(item2, item2Count)
        end,

    }
end

local function onHuntFail()

end

hunt_api.start_hunt(current_area, "羊", onHuntSuccess, onHuntFail)