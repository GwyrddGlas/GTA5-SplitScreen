local natives = require("lib.natives2845")

local players = {
    {id = 1, name = "PlayerOne", pos = {x = 0, y = 0, z = 0}},
    {id = 2, name = "PlayerTwo", pos = {x = 0, y = 0, z = 0}},
}

local function drawText(text, x, y, scale)
    scale = scale or 0.3
    ui.set_text_scale(scale)
    ui.set_text_font(0)
    ui.set_text_color(255, 255, 255, 255)
    ui.set_text_outline(true)
    ui.draw_text(text, v2(x, y))
end

local toggle = false
menu.create_thread(function()
    local key = {
        wKey = MenuKey(),
        aKey = MenuKey(),
        sKey = MenuKey(),
        dKey = MenuKey(),
    }

    key.wKey:push_vk(0x57)  -- 'W' key
    key.aKey:push_vk(0x41)  -- 'A' key
    key.sKey:push_vk(0x53)  -- 'S' key
    key.dKey:push_vk(0x44)  -- 'D' key
    
    local lastPressedTime = 0
    local cooldown = 500
    local moveSpeed = 0.1  -- Adjust as necessary

    while true do
        drawText("Start SplitScreen Controller: back", 0.03, 0.75)
        drawText("Enabled?: " .. tostring(toggle), 0.5, 0.5)

        controls.disable_control_action(0, 0, true) -- Switch Cam
        controls.disable_control_action(0, 31, true)  -- Move Left
        controls.disable_control_action(0, 32, true)  -- Move Right
        controls.disable_control_action(0, 33, true)  -- Move Up
        controls.disable_control_action(0, 34, true)  -- Move Down
        controls.disable_control_action(0, 30, true)  -- Move Down

        if controls.is_control_pressed(0, 217) then
            toggle = not toggle
        end

        -- WASD Controls using the corresponding virtual keys
        if key.wKey:is_down() and (utils.time_ms() - lastPressedTime) >= cooldown then
            lastPressedTime = utils.time_ms()
            local pos = player.get_player_coords(player.player_id())
            pos.y = pos.y - moveSpeed  -- Move Up (W)

            -- Use TASK_TASK_GO_STRAIGHT_TO_COORD
            natives.TASK.TASK_GO_STRAIGHT_TO_COORD(player.player_ped(), pos.x, pos.y, pos.z, moveSpeed, -1, 0.0, 0.0)
        end

        if key.aKey:is_down() and (utils.time_ms() - lastPressedTime) >= cooldown then
            lastPressedTime = utils.time_ms()
            local pos = player.get_player_coords(player.player_id())
            pos.x = pos.x - moveSpeed  -- Move Left (A)

            -- Use TASK_TASK_GO_STRAIGHT_TO_COORD
            natives.TASK.TASK_GO_STRAIGHT_TO_COORD(player.player_ped(), pos.x, pos.y, pos.z, moveSpeed, -1, 0.0, 0.0)
        end

        if key.sKey:is_down() and (utils.time_ms() - lastPressedTime) >= cooldown then
            lastPressedTime = utils.time_ms()
            local pos = player.get_player_coords(player.player_id())
            pos.y = pos.y + moveSpeed  -- Move Down (S)

            -- Use TASK_TASK_GO_STRAIGHT_TO_COORD
            natives.TASK.TASK_GO_STRAIGHT_TO_COORD(player.player_ped(), pos.x, pos.y, pos.z, moveSpeed, -1, 0.0, 0.0)
        end

        if key.dKey:is_down() and (utils.time_ms() - lastPressedTime) >= cooldown then
            lastPressedTime = utils.time_ms()
            local pos = player.get_player_coords(player.player_id())
            pos.x = pos.x + moveSpeed  -- Move Right (D)

            -- Use TASK_TASK_GO_STRAIGHT_TO_COORD
            natives.TASK.TASK_GO_STRAIGHT_TO_COORD(player.player_ped(), pos.x, pos.y, pos.z, moveSpeed, -1, 0.0, 0.0)
        end

        system.wait(0)
    end
end)
