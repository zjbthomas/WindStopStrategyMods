local function get_tired_roles()
    local allRoles = roles_of_menpai(get_player_menpai())
    local results = table.where(allRoles, 
    function(role) 
        return role.RemainBattleJoinCount < role.MaxBattleJoinCount
    end)
    return results
end

-- 寻找所有需要洗尘的门人
local roles = get_tired_roles()
if #roles <= 0 then
    pop_tip(string.i18_format("没有需要洗尘的门人"))
    return -1
end

-- 玩家选择需要洗尘的门人
local isConfirm, selectedRoles = multi_role_select(roles, #roles)
if not isConfirm then
    return -1
end

if selectedRoles.Count <= 0 then
    return -1
end

-- 计算洗尘费用
local playerMenpai = get_player_menpai()
if not playerMenpai then
    print_error("错误，未找到玩家门派")
    return -1
end

local economic = require 'Common/economy'
local income = economic.income_of_menpai(playerMenpai)

local singleCost = math.max(500, math.min(5000, math.floor(0.4 * income))) -- TODO: 费用计算公式可调整
local totalCost = singleCost * selectedRoles.Count

local is_ok = yes_or_no(string.i18_format("本次洗尘{0}人需花费 {1} x {2}, 是否继续？", selectedRoles.Count, item_tip_link("银两"), totalCost))
if not is_ok then
    return -1
end

local money = get_player_money()
if money < totalCost then
    pop_tip(string.i18_format("没有足够的银两洗尘"))
    return -1
end

add_player_money(-totalCost)

-- 执行洗尘
for i, role in pairs(selectedRoles) do
    if role.RemainBattleJoinCount < role.MaxBattleJoinCount then
        role.RemainBattleJoinCount = role.RemainBattleJoinCount + 1
    end
end