local hunt_api = require("Common/hunt")


local function get_bear_hunt_options()
    local options = {
        item_tip_link("野猪齿", i18n_text("用它们的牙打造饰品"), "#000000"),
        i18n_text("卖给当地屠户(1000银两)"),
    }

    local itemProb = math.random(1, 7)
    if itemProb <= 2 then
        item = "豚牙丸"
        itemCount = 2
    elseif itemProb >= 7 then
        item = "赠送豚牙丸"
        itemCount = 1
    else
        item = "豚牙丹"
        itemCount = 3
    end
    if has_flag("已解锁药店") then
        table.insert(options, item_tip_link(item, i18n_text("带回去制成[" .. string.gsub(item, "赠送", "精制") .. "]"), "#000000"))
    end

    return options, item, itemCount
end

local function onHuntSuccess()
    local options, item, itemCount = get_bear_hunt_options()

    local idx = show_avg_select("", "这些猎获的野猪你打算如何处理？", options)
    switch(idx)
    {
        ["1"] = function()
            add_player_item("野猪齿", 1, "#(0-2)")
        end,
        ["2"] = function()
            add_player_money(1000)
        end,
        ["3"] = function()
            add_player_item(item, itemCount)
        end,
    }
end

local function onHuntFail()

end

hunt_api.start_hunt(current_area, "猪", onHuntSuccess, onHuntFail)