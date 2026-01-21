local util = require "Area/util_build"

local buildDevelopPoint = 10

local area = current_area
if not area then
    return
end

if area.Develop >= MaxAreaDevelop then
    pop_tip("建设度已达到最大值")
    return -1
end

local shopId = area.Id .. "商店" -- TODO： 不是最优的获取商店ID的方法

local lockedItems = get_shop_locked_items(shopId, area.Develop)
local lockedIds = table.select(lockedItems, function(k, x) return x.ItemId end)
if #lockedIds == 0 then
    pop_tip("此商店已无未解锁商品")
    return -1
end

local cost = 0
local build_cnt = math.ceil((MaxAreaDevelop - area.Develop) / buildDevelopPoint)
local targetAreaDevelop = area.Develop
for i = 1, build_cnt do
    cost = cost + util.cost_of_build(targetAreaDevelop)

    targetAreaDevelop = targetAreaDevelop + buildDevelopPoint

    local lockedItems = get_shop_locked_items(shopId, targetAreaDevelop)
    local lockedIds = table.select(lockedItems, function(k, x) return x.ItemId end)
    if #lockedIds == 0 then
        break
    end
end

local is_ok = yes_or_no(string.i18_format("本次建设花费 {0} x {1} 提升发展度到 {2}, 是否继续？", item_tip_link("银两"), cost, targetAreaDevelop))
if not is_ok then
    return -1
end

local money = get_player_money()
if money < cost then
    pop_tip("没有足够的银两建设该地块")
    return -1
end

add_player_money(-cost)
change_area_develop(area, targetAreaDevelop - area.Develop)
