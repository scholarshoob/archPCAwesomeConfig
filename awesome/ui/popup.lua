local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

----- Var -----

width = dpi(250)
height = dpi(150)

----- Skeleton -----

local icon = wibox.widget {
	font = beautiful.font_name .. " 40",
	markup = "",
	widget = wibox.widget.textbox,
}

local name = wibox.widget {
	font = beautiful.font_name .. " 12",
	markup = "Volume",
	widget = wibox.widget.textbox,
}

local progress = wibox.widget {
	margins = {top = dpi(6), bottom = dpi(6)},
	max_value = 100,
	min_value = 0,
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	background_color = beautiful.bar_alt,
	color = beautiful.blue,
	bar_border_width = dpi(0),
	widget = wibox.widget.progressbar,
}

local slider = wibox.widget {
	shape = gears.shape.rounded_bar,
	bar_margins = {top = dpi(6), bottom = dpi(6)},
	maximum = 100,
	minimum = 0,
	value = 0,
	-- Sliderr
	bar_active_color = beautiful.blue,
	bar_color = beautiful.bar_alt,
	bar_shape = gears.shape.rounded_bar,
	-- Handle
	handle_shape = gears.shape.circle,
	handle_border_width = dpi(2),
	handle_border_color = beautiful.bar_alt,
	handle_color = beautiful.blue,
	handle_width = dpi(30),
	widget = wibox.widget.slider,
}

slider:connect_signal("property::value", function(_, newValue)
	awful.spawn.with_shell("amixer -D pulse set Master " .. newValue .. "%")
end)

local popup = awful.popup {
	ontop = true,
	visible = false,
	placement = function(c)
		awful.placement.centered(c, {margins = {top = dpi(500)}})
	end,
	shape = function(cr,w,h)
		gears.shape.rounded_rect(cr,w,h,10)
	end,
	widget = wibox.container.margin,
}

popup:setup {
	{
		{
			{
				icon,
				{
					name,
					progress,
					layout = wibox.layout.align.vertical,
				},
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
			},
			margins = {top = dpi(50), bottom = dpi(50), left = dpi(30), right = dpi(30)},
			widget = wibox.container.margin,
		},
		halign = 'center',
		valign = 'center',
		widget = wibox.container.place,
	},
	forced_height = height,
	forced_width = width,
	bg = beautiful.bar,
	widget = wibox.container.background,
}

local timeout = gears.timer {
	timeout = 1,
	autostart = false,
	call_now = true,
	callback = function()
		popup.visible = false
	end
}

local first_time = true
awesome.connect_signal("signal::volume", function(vol,mute)
	
	if first_time then
		first_time = false
	else
		popup.visible = true
		name.markup = "volume"
		progress.color = beautiful.blue

		if mute or vol == 0 then
			progress.value = vol
			icon.markup = ""
		else
			progress.value = vol
			if vol >= 75 then
				icon.markup = ""
			else
				icon.markup = ""
			end
		end

		if popup.visible then
			timeout:again()
		else
			timeout:start()
		end
	end
end)

local second_time = true
awesome.connect_signal("signal::brightness", function(bri)

	if second_time then
		second_time = false
	else
		popup.visible = true

		progress.value = bri
		progress.color = beautiful.yellow
		name.markup = "Brightness"
		icon.markup = ""

		if popup.visible then
			timeout:again()
		else
			timeout:start()
		end
	end
end)
