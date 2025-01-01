local players = {
    {id = 1, name = "PlayerOne", pos = {}},
    {id = 2, name = "PlayerTwo", pos = {}},
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
        purchase = MenuKey(),
    }

    key.purchase:push_vk(0x58) --x keyboard
    local lastPressedTime = 0
    local cooldown = 500 

    while true do
        drawText("Start SplitScreen Controller: back", 0.03, 0.75)
        drawText("Enabled?: "..tostring(toggle), 0.5, 0.5)
        
        controls.disable_control_action(0, 0, true) -- Switch Cam
        controls.disable_control_action(0, 31, true)  -- Move Left
        controls.disable_control_action(0, 32, true)  -- Move Right
        controls.disable_control_action(0, 33, true)  -- Move Up
        controls.disable_control_action(0, 34, true)  -- Move Down
        controls.disable_control_action(0, 30, true)  -- Move Down

        if controls.is_control_pressed(0, 217) then
            toggle = not toggle
        end

        if key.purchase:is_down() and (utils.time_ms() - lastPressedTime) >= cooldown then
            lastPressedTime = utils.time_ms()
            
            local pos = player.get_player_coords(player.player_id())
            pos.x = pos.x + 1
            entity.set_entity_coords_no_offset(player.player_ped(), pos )
        end

        system.wait(0)
    end
end)
