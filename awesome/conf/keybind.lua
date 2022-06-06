local awful = require "awful"

modkey = "Mod4"

-- Keys
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

-- Application Keybinds
awful.keyboard.append_global_keybindings({
    awful.key({modkey,}, "Return", function() awful.spawn(terminal) end,
    {description = "Open terminal", group = "launcher"}),
    
    awful.key({modkey,}, "space", function() awful.spawn.with_shell("rofi -show drun -theme applications -show-icons")end,
    {description = "Open Rofi", group = "layout"}),

    awful.key({"Mod1", }, "Tab",
    function ()
        -- awful.client.focus.history.previous()
        awful.client.focus.byidx(-1)
        if client.focus then
            client.focus:raise()
        end
    end),

    awful.key({"Mod1", "Shift",}, "Tab",
    function ()
        -- awful.client.focus.history.previous()
        awful.client.focus.byidx(1)
        if client.focus then
            client.focus:raise()
        end
    end),
    awful.key({modkey, "Control", "Shift", }, "space", function () awful.layout.inc(-1) end,
        {description = "Toggle floating environment", group = "client"}),
})


-- Mouse Keybinds
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

-- Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({modkey, "Control", }, 3, function() awful.spawn.with_shell("pamixer -t") end),
    awful.button({modkey, "Control", }, 4, function() awful.spawn.with_shell("pamixer -i 3") end),
    awful.button({modkey, "Control", }, 5, function() awful.spawn.with_shell("pamixer -d 3") end),  
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({modkey,}, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({modkey, "Control", }, "q", function (c) c:kill() end,
                {description = "close", group = "client"}),
        awful.key({modkey, "Control", }, "space",  awful.client.floating.toggle,
                {description = "Toggle floating", group = "client"}),
        awful.key({modkey, }, "m",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey, "Control", }, "m",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                c:activate { raise = true, context = "key.unminimize" }
                end
            end,
            {description = "restore minimized", group = "client"}),
    })
end)
