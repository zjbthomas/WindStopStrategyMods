local hunt_api = require("Common/hunt")

local function get_snake_hunt_options()
    local options = {
       i18n_text("卖给当地猎户(1000银两)"),
       item_tip_link("蛇胆解毒丸", i18n_text("带回去制成[解毒丸]"), "#000000"),
    }

    local itemProb = math.random(1, 7)
    if itemProb <= 2 then
        item = "影蛇丸"
        itemCount = 2
    elseif itemProb >= 7 then
        item = "赠送影蛇丸"
        itemCount = 1
    else
        item = "影蛇丹"
        itemCount = 3
    end
    if player_menpai_has_role("汤彩蝶") then
        table.insert(options, item_tip_link(item, i18n_text("带回去给[汤彩蝶]制成[" .. string.gsub(item, "赠送", "精制") .. "]"), "#000000"))
    end

    return options, item, itemCount
end

local function onHuntSuccess()
    local options, item, itemCount = get_snake_hunt_options()

    local idx = show_avg_select("", "这些猎获的蛇你打算如何处理？", options)
    switch(idx)
    {
        ["1"] = function()
            add_player_money(1000)
        end,
        ["2"] = function()
            add_player_item("蛇胆解毒丸", 3)
        end,
        ["3"] = function()
            add_player_item(item, itemCount)
        end,
    }
end

local function onHuntFail()

end

hunt_api.start_hunt(current_area, "蛇", onHuntSuccess, onHuntFail)