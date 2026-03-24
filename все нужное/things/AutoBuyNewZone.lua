Tab:AddToggle({
    Name = "Auto Buy New Zones",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyNEWZONE = Value

        if Value then
            task.spawn(function()
                -- Используем те же модули, что и в твоем декомпиляте
                local ZoneCmds = require(game.ReplicatedStorage.Library.Client.ZoneCmds)
                local ZonesUtil = require(game.ReplicatedStorage.Library.Util.ZonesUtil)
                local Network = require(game.ReplicatedStorage.Library.Client.Network)

                while _G.AutoBuyNEWZONE do
                    -- 1. Получаем данные о максимальной купленной зоне
                    -- (Возвращает объект зоны во втором аргументе)
                    local _, maxZoneData = ZoneCmds.GetMaxOwnedZone()
                    
                    if maxZoneData and maxZoneData.ZoneNumber then
                        -- 2. Находим следующую зону по номеру
                        local nextZoneName, nextZoneData = ZonesUtil.GetZoneFromNumber(maxZoneData.ZoneNumber + 1)
                        
                        -- 3. Если следующая зона существует и у неё есть имя
                        if nextZoneData and nextZoneData.ZoneName then
                            local targetZone = nextZoneData.ZoneName
                            
                            -- Печатаем для отладки в F9
                            print("Попытка купить следующую зону: " .. tostring(targetZone))
                            
                            -- 4. Вызываем покупку через Network (как в оригинале)
                            local success, result = Network.Invoke("Zones_RequestPurchase", targetZone)
                            
                            if success then
                                print("Зона успешно куплена!")
                                task.wait(1) -- Короткая пауза после успеха
                            end
                        end
                    end
                    
                    task.wait(2) -- Проверка каждые 2 секунды
                end
            end)
        end
    end    
})