local function cost_of_build(develop)
    local k = 11 *  math.max(1, develop // 4)
    local cost = math.floor((k * (develop // 7 +1) +(k * 9))  * math.max(0, 1 - restore_api.get_restore_modifier(restore_modifer_key.build_cost_discount)))
    return cost
end

return 
{
    cost_of_build = cost_of_build
}