local hunt_api = require("Common/hunt")

local function get_wolf_hunt_options()
    local options = {
        i18n_text("卖给当地猎户(1000银两)"),
    }

    local itemProb = math.random(1, 7)
    if itemProb <= 2 then
        item = "苍狼丸"
        itemCount = 2
    elseif itemProb >= 7 then
        item = "赠送苍狼丸"
        itemCount = 1
    else
        item = "苍狼丹"
        itemCount = 2
    end
    table.insert(options, item_tip_link(item, i18n_text("带回去制成[" .. string.gsub(item, "赠送", "精制") .. "]"), "#000000"))

    if player_menpai_has_role("秋") then
        table.insert(options, item_tip_link("精良项链", i18n_text("带回去给[秋]"), "#000000"))
    end

    return options, item, itemCount
end

local huntArea = current_area
local function onHuntSuccess()

    change_area_develop(huntArea, 2)
    avg_talk("", "此地的狼患缓解了不少")

    local options, item, itemCount = get_wolf_hunt_options()

    local idx = show_avg_select("", "这些野狼你打算如何处理？", options)
    switch(idx)
    {
        ["1"] = function()
            add_player_money(1000)
        end,
        ["2"] = function()
            add_player_item(item, itemCount)
        end,

        ["3"] = function()
            add_player_item("精良项链", 1, "#(0-5)")
        end,
    }

end

local function onHuntFail()

end

hunt_api.start_hunt(huntArea, "狼", onHuntSuccess, onHuntFail)