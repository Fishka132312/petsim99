_G.AutoCollectRANK = false

local Save = require(game.ReplicatedStorage.Library.Client.Save)
local RanksUtil = require(game.ReplicatedStorage.Library.Util.RanksUtil)
local Directory = require(game.ReplicatedStorage.Library.Directory)
local Network = require(game.ReplicatedStorage.Library.Client.Network)

local function claimAllAvailable()
    local data = Save.Get()
    if not data then return end

    local rankID = RanksUtil.RankIDFromNumber(data.Rank)
    local rankData = Directory.Ranks[rankID]
    if not rankData or not rankData.Rewards then return end

    local currentStars = data.RankStars
    local accumulatedRequired = 0

    for index, reward in ipairs(rankData.Rewards) do
        accumulatedRequired = accumulatedRequired + reward.StarsRequired
        
        if currentStars >= accumulatedRequired and data.RedeemedRankRewards[tostring(index)] == nil then
            Network.Fire("Ranks_ClaimReward", index)
            task.wait(0.5)
        end
    end
end

task.spawn(function()
    while true do
        if _G.AutoCollectRANK then
            pcall(claimAllAvailable)
        end
        task.wait(5)
    end
end)
