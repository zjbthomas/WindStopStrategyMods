local hunt_api = require("Common/hunt")


local function get_bear_hunt_options()
    local options = {
        i18n_text("卖给当地猎户(1500银两)"),
    }

    local itemProb = math.random(1, 7)
    if itemProb <= 2 then
        item = "熊骨丸"
        itemCount = 2
    elseif itemProb >= 7 then
        item = "赠送熊骨丸"
        itemCount = 1
    else
        item = "熊骨丹"
        itemCount = 2
    end
    if has_flag("已解锁药店") then
        table.insert(options, item_tip_link(item, i18n_text("带回去制成[" .. string.gsub(item, "赠送", "精制") .. "]"), "#000000"))
    end

    if player_menpai_has_role("朱三娘") then
        table.insert(options, item_tip_link("红烧熊掌", i18n_text("带回去交给[朱三娘]红烧"), "#000000"))
    end

    return options, item, itemCount
end

local function onHuntSuccess()
    local options, item, itemCount = get_bear_hunt_options()

    local idx = show_avg_select("", "这些猎获的大熊你打算如何处理？", options)
    switch(idx)
    {
        ["1"] = function()
            add_player_money(1500)
        end,
        ["2"] = function()
            add_player_item(item, itemCount)
        end,
        ["3"] = function()
            add_player_item("红烧熊掌", 2)
        end,
    }
end

local function onHuntFail()

end

hunt_api.start_hunt(current_area, "熊", onHuntSuccess, onHuntFail)