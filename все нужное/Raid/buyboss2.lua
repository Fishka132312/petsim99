-- Инициализируем переменную (по умолчанию включено)
_G.BuyBoss2 = false

while true do
    -- Проверяем глобальную переменную
    if _G.Buy then
        local args = {
            2
        }

        -- Выполняем покупку
        game:GetService("ReplicatedStorage")
            :WaitForChild("Network")
            :WaitForChild("Raids_BossChallenge")
            :InvokeServer(unpack(args))
            
        print("Скрипт работает: Покупка сделана")
    else
        -- Если false, просто выводим статус (можно убрать print, если мешает)
        print("Скрипт на паузе: _G.Buy установлен в false")
    end

    task.wait(2) -- Пауза между итерациями
end
