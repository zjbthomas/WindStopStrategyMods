-- ====================================
-- 日常_参与拍卖 - 熊岛拍卖行可重复玩法
-- 玩家可以参与竞拍打捞物品
-- 参与3次后解锁02A_亲自打捞剧情
-- ====================================

black_scene(1)
show_stage("街道2.png", "熊岛街道")
play_bgm("Music/ThunderRain.mp3", 0.2)

-- 拍卖配置常量
local CARGO_MIN = 3
local CARGO_MAX = 8
local RAINY_THRESHOLD = 6

-- 初始化拍卖参数
local isXiongBaTianDead = has_flag("熊霸天已死")
local NumberOfCargoBoxes = math.random(CARGO_MIN, CARGO_MAX)
local isRainy = NumberOfCargoBoxes > RAINY_THRESHOLD
if isRainy then
    local filter = add_camera_filter("CameraFilterPack_Atmosphere_Rain_Pro")
    filter.Fade = 0.65
    play_bgm("Music/ThunderRain.mp3", 0.2)
else
    play_bgm("Music/日常_烟火人间.wav", 0.2)
end
local CurrentCargo = 1                       -- 当前拍卖物品索引
local CargoBoxes = {
    { quality = 1, status = i18n_text("破烂不堪"), startingPrice = math.random(200, 400), id = "破烂不堪的箱子" },
    { quality = 2, status = i18n_text("普普通通"), startingPrice = math.random(400, 1200), id = "普普通通的箱子" },
    { quality = 3, status = i18n_text("十分精致"), startingPrice = math.random(700, 2000), id = "十分精致的箱子" },
}

local function leave_auction()
    if NumberOfCargoBoxes > 6 then
        remove_camera_filter("CameraFilterPack_Atmosphere_Rain_Pro")
    end

    local join_count = get_flag_int("参与熊岛拍卖次数")
    set_flag_int("参与熊岛拍卖次数", join_count + 1)

    if join_count >= 3 then
        set_flag("多次参与熊岛拍卖")
    end

    set_flag("本回合已参加拍卖")


    black_scene(0.5)
    hide_stage()
    light_scene(0.25)
end

--初始化角色和角色位置
local situ = actor("司徒来也")
local xiongbatian = isXiongBaTianDead and actor("[speaker:熊二][img:pawn_HaoZhuChangLong_male_4]") or actor("熊霸天")
local npcActors = {
    actor("村民1"),
    actor("村民2"),
    actor("村民3")
}

local npcMoneys = {
    math.random(5000, 10000),
    math.random(10000, 15000),
    math.random(7000, 12000)
}

dark_all_actors()
npcActors[1]:setPos(150, 75)
npcActors[1]:face_right()
situ:setPos(450, 75)
situ:face_right()
xiongbatian:setPos(920, 85)
xiongbatian:setScale(1.3)
xiongbatian:face_left()
npcActors[2]:setPos(1500, 75)
npcActors[2]:face_left()
npcActors[3]:setPos(1800, 75)
npcActors[3]:face_left()
--角色名字与属性设置
for i, npc in ipairs(npcActors) do
    npc:GenRandomName()
    npc:setRandomPic(chance(50))
end

light_scene(1)
--剧情开始
--熊老板说话
wait_twn(xiongbatian:flip(), xiongbatian:daze(0.3), xiongbatian:flip())

if has_flag("熊霸天已死") then
    if has_flag("熊二第一次拍卖") then
        xiongbatian:say("诸位再临熊岛，我自当照例主持拍卖。")
        if NumberOfCargoBoxes > 6 then
            xiongbatian:say("风雨未歇，货色倒是不少。")
        else
            xiongbatian:say("风雨暂歇，今日货色也还齐整。")
        end
        xiongbatian:say("规矩不变——银货两讫，各位尽管下手。")
        set_flag("熊二第一次拍卖")
    else
        xiongbatian:sad("……诸位，吾兄霸天遭歹人所害。今日起，这拍卖由我熊二接手。")
        stage_narration("场内一时静默，唯有海潮声不绝。")
        situ:say("唉……熊霸天……愿他安息。")
        npcActors[1]:say("熊爷一路走好。")
        npcActors[2]:say("都是风浪所逼，熊岛人不易。")
        npcActors[3]:say("如今我等受虎焰门庇护，岛内岛外风浪止息，老熊泉下有知，想必也无憾了。")
        xiongbatian:say("人亡事未绝，风浪再大，买卖照开。")
        xiongbatian:say("规矩不改——银货两讫，童叟无欺。")
    end
else
    xiongbatian:say("哈哈哈，熊某今日荣幸，众位英雄侠士肯前来捧场！")
    if NumberOfCargoBoxes > 6 then
        xiongbatian:say("近日运势通畅，竟意外捞得几件好货。")
    else
        xiongbatian:say("近日风雨不顺，捞来的货物颇为寥落，略感遗憾。")
    end
    xiongbatian:say("诸位都是江湖中人，规矩自不必多言——")
    xiongbatian:say("一旦弃权，后续不得再出价！")
    xiongbatian:say("且看今日这几件宝贝如何吧！")
end

--NPC对箱子吐槽
while CurrentCargo <= NumberOfCargoBoxes do
    local randomIndex = math.random(1, #CargoBoxes)
    local selectedCargo = CargoBoxes[randomIndex]
    local commentator = npcActors[math.random(1, #npcActors)]
    xiongbatian:say("眼下呈上的这一件，看上去{0}。", selectedCargo.status)
    if chance(30) then
        if selectedCargo.quality == 1 then
            local lines = i18n_options {
                "这箱子里怕是装的破铜烂铁吧？",
                "这等破物，连江湖乞丐都嫌弃吧！",
                "此物怕是难入法眼，真是浪费时间。"
            }
            commentator:say(lines[math.random(#lines)])
        elseif selectedCargo.quality == 2 then
            local lines = i18n_options {
                "瞧着还算凑合，也许能淘点有趣的东西。",
                "这东西虽普通，倒也未必一无是处。",
                "莫非其中藏着什么玄机不成？"
            }
            commentator:say(lines[math.random(#lines)])
        elseif selectedCargo.quality == 3 then
            local lines = i18n_options {
                "啧啧，这么好的箱子，里面说不定是宝贝！",
                "如此精美之物，必定来头不小！",
                "这般精致，真是让人心生向往啊。"
            }
            commentator:say(lines[math.random(#lines)])
        end
    end


    --起拍价
    xiongbatian:say("起拍价仅需{0}两！", selectedCargo.startingPrice)

    --初始化
    local currentBid = selectedCargo.startingPrice
    local highestBidder = nil
    local highestBidderIdx = nil
    local bidsMade = false
    local playerContinues = true
    local npcBidProbability = 0
    if selectedCargo.quality == 1 then
        npcBidProbability = 60 -- 原数值：30
    elseif selectedCargo.quality == 2 then
        npcBidProbability = 70 -- 原数值：50
    elseif selectedCargo.quality == 3 then
        npcBidProbability = 85 -- 原数值：70
    end

    local npcActorsContinues = {true, true, true} -- NPC是否继续竞拍标志

    --NPC竞拍
    for i = 1, #npcActors do
        local randomBid = math.random(100, 300) -- 原数值：50-300
        local bidAmount = currentBid + randomBid

        if npcMoneys[i] >= bidAmount and chance(npcBidProbability - math.floor(bidAmount / npcMoneys[i] * 20)) then
            if chance(30) then
                npcActors[i]:jump()
            end
            npcActors[i]:say("熊老板，我愿出价{0}两！", bidAmount)
            if chance(30) then
                local lines = i18n_options {
                    "谁敢跟我抢？别怪我不客气！",
                    "哼！今日拍卖，我势在必得！",
                    "诸位还是省省力气吧，早晚是我的！"
                }
                npcActors[i]:say(lines[math.random(#lines)])
            end
            currentBid = bidAmount
            highestBidder = npcActors[i]
            highestBidderIdx = i
            bidsMade = true
        else
            npcActors[i]:say("在下弃权。")

            npcActorsContinues[i] = false
        end
    end

    --玩家竞拍
    while playerContinues do
        local options = i18n_options {
            "加价100",
            "加价500", -- 原数值：200
            "不出价",
            "离开拍卖"
        }

        local validSelection = false
        while not validSelection do
            -- 获取玩家当前的金钱
            local playerMoney = get_player_money()

            -- 显示选项菜单
            local msg = string.i18_format("当前最高出价为{0}两，您的现有银两为{1}两。请选择您的出价选项：", currentBid, playerMoney)
            local idx = show_avg_select("", msg, options)

            if idx == 1 then
                if playerMoney < currentBid + 100 then
                    avg_talk("", "您的银两不足，无法加价！")
                else
                    local situBid = currentBid + 100
                    if chance(30) then
                        situ:jump()
                    end
                    situ:say("在下愿出{0}两！", situBid)
                    currentBid = situBid
                    highestBidder = situ
                    highestBidderIdx = nil
                    bidsMade = true
                    validSelection = true
                end
            elseif idx == 2 then
                if playerMoney < currentBid + 500 then
                    avg_talk("", "您的银两不足，无法加价！")
                else
                    local situBid = currentBid + 500
                    if chance(30) then
                        situ:jump()
                    end
                    situ:say("在下愿出{0}两！", situBid)
                    currentBid = situBid
                    highestBidder = situ
                    highestBidderIdx = nil
                    bidsMade = true
                    npcBidProbability = math.max(30, npcBidProbability - 5) -- 原数值：减少10，最低10
                    validSelection = true
                end
            elseif idx == 3 then
                situ:say("此物与我无缘，不再加价。")
                playerContinues = false
                validSelection = true
            else
                situ:say("熊老板，我先离开了。")
                xiongbatian:say("慢走不送，后会有期！")
                playerContinues = false
                CurrentCargo = NumberOfCargoBoxes + 1
                validSelection = true
            end
        end

        if CurrentCargo > NumberOfCargoBoxes then
            leave_auction()
            return
        end

        if not bidsMade then
            playerContinues = false
        end
        --NPC继续竞拍
        if bidsMade then
            local npcContinues = false
            for i = 1, #npcActors do
                if npcActorsContinues[i] then
                    local randomBid = math.random(100, 300) -- 原数值：50-300
                    local bidAmount = currentBid + randomBid

                    if npcMoneys[i] >= bidAmount and chance(npcBidProbability - math.floor(bidAmount / npcMoneys[i] * 20)) then
                        if chance(30) then
                            npcActors[i]:jump()
                        end
                        npcActors[i]:say("我愿出价{0}两！", bidAmount)
                        if chance(30) then
                            local lines = i18n_options {
                                "就凭你也想赢过我？再加点吧！",
                                "哈哈，你的银子怕是不够吧？",
                                "可别做无用之争，徒增笑料！"
                            }
                            npcActors[i]:say(lines[math.random(#lines)])
                        end
                        currentBid = bidAmount
                        highestBidder = npcActors[i]
                        highestBidderIdx = i
                        npcContinues = true
                    else
                        npcActors[i]:say("在下不再加价。")

                        npcActorsContinues[i] = false
                    end
                end
            end

            if not npcContinues then
                break
            end
        end
    end

    --最终得主
    if not bidsMade then
        xiongbatian:say("竟无一人出价，此物暂且留待他日。")
    else
        local receiverName = "？？？"
        if highestBidder then
            receiverName = highestBidder:GetActorName()
        end
        xiongbatian:say("最终得主乃是：{0}，以{1}两拍得！", receiverName, currentBid)
        if highestBidder == situ then
            add_player_item(selectedCargo.id, 1)
            add_player_money(-currentBid)
        elseif highestBidderIdx then
            npcMoneys[highestBidderIdx] = npcMoneys[highestBidderIdx] - currentBid
        end
    end

    CurrentCargo = CurrentCargo + 1

    if CurrentCargo <= NumberOfCargoBoxes then
        wait_twn(xiongbatian:flip(), xiongbatian:daze(0.3), xiongbatian:flip())
        xiongbatian:say("下一件宝物即将呈上！")
    end
end

--退出拍卖
xiongbatian:say("今日拍卖已毕，多谢诸位英雄侠士光临，后会有期！")
leave_auction()
